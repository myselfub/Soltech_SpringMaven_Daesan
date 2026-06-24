<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>종합관제-시설현황</title>
<style>
</style>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/css/view/db0103.css" />
</head>
<body>
	<div class="navi-box">
		<div class="navi-contents">
			<div class="navi-path active" id="1" onclick="onClickNavi(this.id);">
				<p>공정 메인</p>
			</div>
		</div>
		<div class="navi-contents">
			<div class="navi-path " id="5" onclick="onClickNavi(this.id);">
				<p>평면도</p>
			</div>
		</div>
		<div class="navi-contents">
			<div class="navi-path " id="3" onclick="onClickNavi(this.id);">
				<p>공정도</p>
			</div>
		</div>
		<div class="navi-contents">
			<div class="navi-path " id="2" onclick="onClickNavi(this.id);">
				<p>계통도</p>
			</div>
		</div>
	</div>
	<div id="contents"></div>
	<script>
		const dataObj = {
			isEvent: false,
			eventTime: 1,
			timeOutTime: 5,
			timeOutId: null
		};

		window.onload = function() {
			loadMain();
			/*
			$("#contents").load("resources/html/contents1.html?time=" + (new Date()).format("yyyymmddhhmmss"), function () {
				init()
			});
			*/
		};

		function ajaxImg(imgNm) {
			return new Promise((resolve, reject) => {
				$.ajax ({
					type: "GET",
					contentType: "xml; charset=UTF-8",
					url: "resources/images/view/db/db0103/" + imgNm,
					cache: true,
					success: function(res) {
						let emtSvg = res.documentElement;

						// SVG 넓이 조정
						emtSvg.setAttribute("width", "100%");
						emtSvg.setAttribute("height", "100%");
						emtSvg.setAttribute("preserveAspectRatio", "none");
						resolve(emtSvg);
					},
					error: function(e) {
						console.error(e);
					}
				});
			});
		};

		function ajaxData(tagList) {
			let newTagList = [];
			tagList.forEach(item => {
				if (item.includes(",")) {
					if (item.toLowerCase().startsWith("sum(") ||
						item.toLowerCase().startsWith("max(") ||
						item.toLowerCase().startsWith("min(") ||
						item.toLowerCase().startsWith("or(") ||
						item.toLowerCase().startsWith("and(")) {
						let prefix = item.substr(0, item.indexOf("("));
						let tempTagNames = item.substr(item.indexOf("(") + 1);
						if (tempTagNames.endsWith(")")) {
							tempTagNames = tempTagNames.substr(0, tempTagNames.length - 1);
						}
						let splited = tempTagNames.split(",");
						splited.forEach(splitedItem => {
							newTagList.push(splitedItem.trim());
						});
					} else {
						let splited = item.split(",");
						splited.forEach(splitedItem => {
							newTagList.push(splitedItem.trim());
						});
					}
				} else {
					newTagList.push(item);
				}
			});
			return new Promise((resolve, reject) => {
				let obj = {
					"cmd" : "reqValues",
					"timeout" : 15 * 1000,
					"dest" : "historian",
					"param" : {
						"tagList" : Array.from(new Set(newTagList))
					}
				}

				$.ajax ({
					type: "POST",
					contentType: "application/json; charset=UTF-8",
					url: "/reqHistorian",
					dataType: "json",
					cache: true,
					data: JSON.stringify(obj),
					success: function(res) {
						let resultParam = res.param;
						let newResultParam = [];
						tagList.forEach(tagName => {
							let resultItem = null;
							if (tagName.includes(",")) {
								if (tagName.toLowerCase().startsWith("sum(") ||
									tagName.toLowerCase().startsWith("max(") ||
									tagName.toLowerCase().startsWith("min(") ||
									tagName.toLowerCase().startsWith("or(") ||
								tagName.toLowerCase().startsWith("and(")) {
									let prefix = tagName.substr(0, tagName.indexOf("("));
									let tempTagNames = tagName.substr(tagName.indexOf("(") + 1);
									if (tempTagNames.endsWith(")")) {
										tempTagNames = tempTagNames.substr(0, tempTagNames.length - 1);
									}
									let splited = tempTagNames.split(",");
									let resultName = "";
									let resultVal = "";
									splited.forEach(splitedItem => {
										resultItem = resultParam.find(paramItem => paramItem.name == splitedItem);
										if (resultItem) {
											resultName = resultName + resultItem.name + ",";
											resultVal = resultVal + resultItem.val + ",";
										}
									});
									if (resultName.endsWith(",")) {
										resultName = resultName.slice(0, -1);
									}
									if (resultVal.endsWith(",")) {
										resultVal = resultVal.slice(0, -1);
									}
									resultVal = prefix + "::" + resultVal;
									if (resultItem) {
										resultItem.name = resultName;
										resultItem.val = resultVal;
									}
								} else {
									let splited = tagName.split(",");
									let resultName = "";
									let resultVal = "";
									splited.forEach(splitedItem => {
										resultItem = resultParam.find(paramItem => paramItem.name == splitedItem);
										if (resultItem) {
											resultName = resultName + resultItem.name + ",";
											resultVal = resultVal + resultItem.val + ",";
										}
									});
									if (resultName.endsWith(",")) {
										resultName = resultName.slice(0, -1);
									}
									if (resultVal.endsWith(",")) {
										resultVal = resultVal.slice(0, -1);
									}
									if (resultItem) {
										resultItem.name = resultName;
										resultItem.val = resultVal;
									}
								}
							} else {
								// 1. 정확히 일치하는 태그 찾기
								resultItem = resultParam.find(paramItem => paramItem.name == tagName);

								// 2. 못 찾으면 결합된 태그명에서 찾기 (Historian이 결합된 이름으로 반환하는 경우)
								if (!resultItem) {
									let combinedResult = resultParam.find(paramItem =>
										paramItem.name && paramItem.name.includes(",") && paramItem.name.includes(tagName)
									);
									if (combinedResult && combinedResult.val) {
										// 결합된 태그에서 해당 태그의 값 추출
										let tagNames = combinedResult.name.split(",");
										let tagValues = String(combinedResult.val).split(",");
										let tagIndex = tagNames.findIndex(t => t.trim() == tagName);
										if (tagIndex >= 0 && tagIndex < tagValues.length) {
											resultItem = {
												"name": tagName,
												"time": combinedResult.time,
												"val": tagValues[tagIndex],
												"conf": combinedResult.conf
											};
										}
									}
								}

							}
							if (!resultItem) {
								resultItem = {
									"name" : tagName,
									"time" : null,
									"val" : null,
									"conf" : 0
								};
							}
							newResultParam.push(resultItem);
						});
						res.param = newResultParam;
						resolve(res);
					},
					error: function(e) {
						console.error(e);
					}
				});
			});
		};

		function timeOutData(func) {
			if (dataObj.timeOutId) {
				clearTimeout(dataObj.timeOutId);
				dataObj.timeOutId = null;
			}
			let timeOutFunc = () => {
				func();
				dataObj.timeOutId = setTimeout(timeOutFunc, dataObj.timeOutTime * 1000);
			};
			func();
			dataObj.timeOutId = setTimeout(timeOutFunc, dataObj.timeOutTime * 1000);
		};

		function calcData(itemVal) {
			let resultData = null;
			let prefix = itemVal.substr(0, itemVal.indexOf("::"));
			let tempItemVal = itemVal.substr(itemVal.indexOf("::") + "::".length);
			let splited = String(tempItemVal).split(",");

			if (prefix.toLowerCase() == "sum") {
				resultData = splited.reduce((sum, splitedItem) => sum += Number(splitedItem), 0);
			} else if (prefix.toLowerCase() == "max") {
				resultData = Math.max(splited);
			} else if (prefix.toLowerCase() == "min") {
				resultData = Math.min(splited);
			} else if (prefix.toLowerCase() == "and") {
				resultData = false;
				splited.forEach(splitedItem => {
					resultData = resultData && Number(splitedItem) == 1;
				});
			} else if (prefix.toLowerCase() == "or") {
				resultData = false;
				splited.forEach(splitedItem => {
					resultData = resultData || Number(splitedItem) == 1;
				});
			} else {
				resultData = false;
				splited.forEach(splitedItem => {
					resultData = resultData || Number(splitedItem) == 1;
				});
			}

			return resultData;
		};

		function setDataAtt(tagMapping, emtSvg) {
			Object.keys(tagMapping).forEach(key => {
				let emt = emtSvg.querySelector("#" + key);
				let textEmt = null;
				if (emt) {
					if (emt.tagName && emt.tagName.toLowerCase() == "text") {
						textEmt = emt.querySelector("tspan");
					} else if (emt.tagName && (emt.tagName.toLowerCase() == "tspan" || emt.tagName.toLowerCase() == "span")) {
						textEmt = emt;
					} else if (emt.tagName && emt.tagName.toLowerCase() == "img") {
						textEmt = emt;
					} else if (emt.tagName && (emt.tagName.toLowerCase() == "g" || emt.tagName.toLowerCase() == "circle")) {
						textEmt = emt;
					}
				} else if (!emt && key.endsWith("-")) {
					textEmt = emtSvg.querySelector("#" + key + "off");
				}
				if (textEmt) {
					textEmt.setAttribute("data-tag", tagMapping[key]);
				}
			});
		};

		/* 공정메인 */
		function loadMain() {
			dataObj.tagMapping = {
				"hhTotalDataBarData-01" : "CDSWSS.TMTC_HH_FIQ701D.F_CV",
				"hhTotalDataBarData-02" : "CDSWSS.TMTC_HH_FIT701D.F_CV",
				"lgDataBarData-01" : "CDSWSS.TMTC_LG_FIQ701B.F_CV",
				"lgDataBarData-02" : "CDSWSS.TMTC_LG_FIT701B.F_CV",
				"hdOciDataBarData-01" : "CDSWSS.TMTC_HO_FIQ701C.F_CV",
				"hdOciDataBarData-02" : "CDSWSS.TMTC_HO_FIT701C.F_CV",
				"hdOilDataBarData-01" : "CDSWSS.TMTC_HB_FIQ701A.F_CV",
				"hdOilDataBarData-02" : "CDSWSS.TMTC_HB_FIT701A.F_CV",
			};

			// SVG
			ajaxImg("main.svg").then((emtSvg) => {
				// 데이터바
				emtSvg.querySelectorAll("#grpDataBar text[id*='Data-']").forEach(emt => {
					emt.classList.add("data-text");
				});

				// 데이터바 화살표
				let emtDataBarArrow = emtSvg.querySelector("#dataBarArrow");
				emtDataBarArrow.classList.add("clickable");
				emtDataBarArrow.addEventListener("click", function() {
					let emtDatabar = emtDataBarArrow.parentElement;
					if (emtDatabar.classList.contains("databar-hide")) {
						emtDatabar.classList.remove("databar-hide");
					} else {
						emtDatabar.classList.add("databar-hide");
					}
				});

				// 툴팁
				[...emtSvg.querySelector("#grpTooltip").children].forEach(emt => {
					let emtId = emt.id;
					emt.classList.add("display-none");
					if (!["pipe"].some(str => emtId.includes(str))) {
						let pathEmt = emtSvg.querySelector("#" + emtId.replace("TooltipBox", "MapPiece"));
						if (pathEmt) {
							emt.addEventListener("mouseenter", function() {
								if (!dataObj.isEvent && !pathEmt.classList.contains("map-piece-hover")) {
									dataObj.isEvent = true;
									pathEmt.classList.add("map-piece-hover");
								}
							});
							emt.addEventListener("mouseleave", function() {
								if (pathEmt.classList.contains("map-piece-hover")) {
									pathEmt.classList.remove("map-piece-hover");
								}
							});
						}
					}
				});

				// 지도영역
				let emtMapPiece = emtSvg.querySelector("#grpBg #mapPieces");
				[...emtMapPiece.children].forEach(emt => {
					emt.classList.add("clickable");
					emt.classList.add("map-piece");
					emt.addEventListener("mouseenter", function() {
						if (!dataObj.isEvent && !emt.classList.contains("map-piece-hover")) {
							dataObj.isEvent = true;
							emt.classList.add("map-piece-hover");
						}
					});
					emt.addEventListener("mouseleave", function() {
						if (emt.classList.contains("map-piece-hover")) {
							emt.classList.remove("map-piece-hover");
						};
					});
				});
				let observer = new MutationObserver(function(mutations) {
					mutations.forEach(function(mutation) {
						let observeTarget = mutation.target;
						let emtTooltip = emtSvg.querySelector("#" + observeTarget.id.replace("MapPiece", "TooltipBox"));
						if (emtTooltip) {
							if (observeTarget.classList.contains("map-piece-hover")) {
								emtTooltip.classList.remove("display-none");
							} else {
								emtTooltip.classList.add("display-none");
							}
						}
						if (dataObj.isEvent) {
							setTimeout(() => {
								dataObj.isEvent = false;
							}, dataObj.eventTime);
						}
					});
				});
				observer.observe(emtMapPiece, {
					childList: false, // 자식 추가 제거 감지
					characterData: false, // 텍스트 값 변경 감지
					subtree: true, // 하위노드 변경 감지
					attributes: true, // 속성 변경 감지
					attributeFilter: ["class"], // 클래스 변경 감지
					attributeOldValue: false, // 과거 속성 저장 여부
					characterDataOldValue: false // 과거 텍스트 저장 여부
				});

				// 네임태그
				[...emtSvg.querySelector("#grpNameTags").children].forEach(emt => {
					let emtId = emt.id;
					if (!["dsan", "asan"].some(str => emtId.includes(str))) {
						emt.classList.add("clickable");
						let pathEmt = emtSvg.querySelector("#" + emtId.replace("TextBox", "MapPiece"));
						if (pathEmt) {
							emt.addEventListener("mouseenter", function() {
								if (!dataObj.isEvent && !pathEmt.classList.contains("map-piece-hover")) {
									dataObj.isEvent = true;
									pathEmt.classList.add("map-piece-hover");
								}
							});
							emt.addEventListener("mouseleave", function() {
								if (pathEmt.classList.contains("map-piece-hover")) {
									pathEmt.classList.remove("map-piece-hover");
								}
							});
						} else {
							let emtTooltips = emtSvg.querySelectorAll("#grpTooltip > g[id^='pipe'][id$='TooltipBox']");
							emt.addEventListener("click", function() {
								onClickNavi("2");
							});
							emt.addEventListener("mouseenter", function() {
								if (!dataObj.isEvent) {
									dataObj.isEvent = true;
									emtTooltips.forEach(emtTooltip => {
										emtTooltip.classList.remove("display-none");
									});
									setTimeout(() => {
										dataObj.isEvent = false;
									}, dataObj.eventTime);
								}
							});
							emt.addEventListener("mouseleave", function() {
								emtTooltips.forEach(emtTooltip => {
									emtTooltip.classList.add("display-none");
								});
							});
						}
					}
				});

				// 라인
				[...emtSvg.querySelector("#grpLines").children].forEach(emt => {
					let emtId = emt.id;
					if (emtId.includes("Line")) {
						emt.classList.add("map-lines");
					}
					if (["redIcon"].some(str => emtId.includes(str))) {
						emt.classList.add("clickable");
						let emtTooltips = emtSvg.querySelectorAll("#grpTooltip > g[id^='pipe'][id$='TooltipBox']");
						let emtLines = emtSvg.querySelectorAll("#grpLines > *:is(g, path)[id*='orangeLine']");
						emt.addEventListener("mouseenter", function() {
							if (!dataObj.isEvent) {
								dataObj.isEvent = true;
								emtTooltips.forEach(emtTooltip => {
									emtTooltip.classList.remove("display-none");
								});
								emtLines.forEach(emtLine => {
									emtLine.classList.add("map-lines-hover");
								});
								setTimeout(() => {
									dataObj.isEvent = false;
								}, dataObj.eventTime);
							}
						});
						emt.addEventListener("mouseleave", function() {
							emtTooltips.forEach(emtTooltip => {
								emtTooltip.classList.add("display-none");
							});
							emtLines.forEach(emtLine => {
								emtLine.classList.remove("map-lines-hover");
							});
						});
						emt.addEventListener("click", function() {
							onClickNavi("2");
						});
					}
				});

				// 데이터 어트리뷰트 셋팅
				setDataAtt(dataObj.tagMapping, emtSvg);

				// 데이터 바인딩
				let ajaxDataFunc = () => {
					ajaxData(Object.values(dataObj.tagMapping)).then((res) => {
						if (res) {
							res.param.forEach(item => {
								let emts = emtSvg.querySelectorAll("[data-tag='" + item.name + "']");
								if (emts.length == 0) {
									emts = emtSvg.querySelectorAll("[data-tag*='" + item.name + "']");
								}
								emts.forEach(emt => {
									if (emt.tagName && (emt.tagName.toLowerCase() == "tspan" || emt.tagName.toLowerCase() == "span")) {
										let preText = emt.textContent;
										let itemVal = item.val;
										if (itemVal != null) {
											if (preText != itemVal.toLocaleString("ko-KR")) {
												emt.textContent = itemVal.toLocaleString("ko-KR");
											}
										} else {
											emt.textContent = itemVal;
										}
									}
								});
							});
						}
					});
				};
				timeOutData(ajaxDataFunc);

				$("#contents").html(emtSvg);
			});
		};

		/* 평면도 */
		function loadFloorPlan() {
			dataObj.tagMapping = {
				"data01Content-Data01" : "CDSWSS.FIT201.F_CV",
				"data01Content-Data02" : "CDSWSS.FIT202.F_CV",
				"data01Content-Data03" : "CDSWSS.LIT201A.F_CV",
				"data01Content-Data04" : "CDSWSS.LIT201B.F_CV",
				"data02Content-Data01" : "CDSWSS.FIT202.F_CV",
				"data02Content-Data02" : "CDSWSS.FIT301.F_CV",
				"data02Content-Data03" : "CDSWSS.LIT202.F_CV",
				"data03Content-Data01" : "CDSWSS.FIT301.F_CV",
				"data03Content-Data02" : "CDSWSS.FIT324.F_CV",
				"data03Content-Data03" : "CDSWSS.LIT321A.F_CV",
				"data03Content-Data04" : "CDSWSS.LIT321B.F_CV",
				"data04Content-Data01" : "SUM(CDSWSS.FIT411S.F_CV,CDSWSS.FIT421S.F_CV,CDSWSS.FIT431S.F_CV,CDSWSS.FIT441S.F_CV,CDSWSS.FIT451S.F_CV,CDSWSS.FIT461S.F_CV)",
				"data04Content-Data02" : "SUM(CDSWSS.FIT412S.F_CV,CDSWSS.FIT422S.F_CV,CDSWSS.FIT432S.F_CV,CDSWSS.FIT442S.F_CV,CDSWSS.FIT452S.F_CV,CDSWSS.FIT462S.F_CV)",
				"data05Content-Data01" : "SUM(CDSWSS.FIT411B.F_CV,CDSWSS.FIT421B.F_CV,CDSWSS.FIT431B.F_CV,CDSWSS.FIT441B.F_CV,CDSWSS.FIT451B.F_CV,CDSWSS.FIT461B.F_CV)",
				"data05Content-Data02" : "SUM(CDSWSS.FIT412B.F_CV,CDSWSS.FIT422B.F_CV,CDSWSS.FIT432B.F_CV,CDSWSS.FIT442B.F_CV,CDSWSS.FIT452B.F_CV,CDSWSS.FIT462B.F_CV)",
				"data05Content-Data03" : "SUM(CDSWSS.FIT413B.F_CV,CDSWSS.FIT423B.F_CV,CDSWSS.FIT433B.F_CV,CDSWSS.FIT443B.F_CV,CDSWSS.FIT453B.F_CV,CDSWSS.FIT463B.F_CV)",
				"data06Content-Data01" : "CDSWSS.FIT481.F_CV",
				"data06Content-Data02" : "CDSWSS.FIT482.F_CV",
				"data06Content-Data03" : "CDSWSS.LIT481A.F_CV",
				"data06Content-Data04" : "CDSWSS.LIT481B.F_CV",
				"topTooltipIcon-01" : "CDSWSS.M106A_RUN_STS.F_CV",
				"topTooltipIcon-02" : "CDSWSS.M106B_RUN_STS.F_CV",
				"topTooltipIcon-03" : "CDSWSS.M106C_RUN_STS.F_CV",
			};

			dataObj.tooltipText = {
				"data01Img" : {
					"TooltipTitle" : "원수저류조",
					"TooltipText01" : "유입유량: {data1}/일, {data2}/hr",
					"TooltipText02" : "체류시간: {data1}h (8,395㎥)",
					"TooltipText03" : "W26.75*L29.8*H5L.35*2지({data1}hr)",
					"TooltipText04" : "",
					"TooltipText05" : ""
				},
				"data02Img" : {
					"TooltipTitle" : "DAF(전전처리)",
					"TooltipText01" : "포화공기가압수 (15%)",
					"TooltipText02" : "제거율 TSS (90%), Oil(90%)",
					"TooltipText03" : "&emsp;TOC(70%), 회수율(99.7%)",
					"TooltipText04" : "",
					"TooltipText05" : ""
				},
				"data03Img" : {
					"TooltipTitle" : "DMGF(전처리)",
					"TooltipText01" : "TSS 15mg/L (10NTU 이하)",
					"TooltipText02" : "DAF 바이패스(-/일)",
					"TooltipText03" : "TSS 15mg/L (10NTU 초과)",
					"TooltipText04" : "DAF 공정 운영 (220,989/일)",
					"TooltipText05" : "(반송량포함) 253,498/일"
				},
				"data04Img" : {
					"TooltipTitle" : "SWRO",
					"TooltipText01" : "유입량: 227,891/일",
					"TooltipText02" : "플럭스: 11.86LMH",
					"TooltipText03" : "회수율: 49%",
					"TooltipText04" : "생산량: 111,667/일",
					"TooltipText05" : ""
				},
				"data05Img" : {
					"TooltipTitle" : "BWRO",
					"TooltipText01" : "유입량: 111,667/일",
					"TooltipText02" : "플럭스: 25.93LMH",
					"TooltipText03" : "회수율: 90%",
					"TooltipText04" : "생산량: 100,500/일",
					"TooltipText05" : ""
				},
				"data06Img" : {
					"TooltipTitle" : "생산수조",
					"TooltipText01" : "유입량: 100,000/일",
					"TooltipText02" : "체류시간: 3.72 Hr",
					"TooltipText03" : "",
					"TooltipText04" : "",
					"TooltipText05" : ""
				}
			};

			// SVG
			ajaxImg("floorPlan.svg").then((emtSvg) => {
				emtSvg.querySelectorAll("#LeftGrp text[id*='-Data']").forEach(emt => {
					emt.classList.add("data-text");
				});

				emtSvg.querySelectorAll("#LeftGrp g[id^='data'][id$='Img'] > g[id*='Img-NameTag0']").forEach(emt => {
					emt.classList.add("display-none");
				});

				emtSvg.querySelectorAll("#RightGrpTop #grpRightGrpTopTooltipIcons > g[id^='topTooltipIcon'] > g[id^='topTooltipIcon-'][id$='Icon'] > circle:first-child").forEach(emtCircle => {
					emtCircle.setAttribute("stroke-width", "2.5");
				});

				let bottomToolTip = emtSvg.querySelector("#RightGrpBottom-Tooltip");
				if (bottomToolTip) {
					bottomToolTip.classList.add("display-none");
				}
				let bottomToolTipTitle = emtSvg.querySelector("#RightGrpBottom-Tooltip #RightGrpBottom-TooltipTitle");
				if (bottomToolTipTitle) {
					bottomToolTipTitle.style.fontWeight = "bold";
				}

				emtSvg.querySelectorAll("#LeftGrp g[id^='data'][id$='Img'] > [id*='Img-Bg']").forEach(emt => {
					emt.classList.add("left-grp-img-bg");
					emt.classList.add("clickable");
				});

				emtSvg.querySelectorAll("#RightGrpBottom #RightGrpBottom-Gif > #RightGrpBottom-Gif-Blue [id^='Gif-Blue-Img']").forEach(gifImg => {
					let newTag = document.createElement("image");
					newTag.classList.add("gif-blue-img");
					gifImg.getAttributeNames().forEach(attr => {
						if (attr != "fill") {
							newTag.setAttribute(attr, gifImg.getAttribute(attr));
						} else {
							newTag.setAttribute("href", "/resources/images/view/db/db0103/lineBlue.gif");
						}
					});
					gifImg.outerHTML = newTag.outerHTML;
				});

				emtSvg.querySelectorAll("#RightGrpBottom #RightGrpBottom-Gif > #RightGrpBottom-Gif-Orange [id^='Gif-Orange-Img']").forEach(gifImg => {
					let newTag = document.createElement("image");
					newTag.classList.add("gif-orange-img");
					gifImg.getAttributeNames().forEach(attr => {
						if (attr != "fill") {
							newTag.setAttribute(attr, gifImg.getAttribute(attr));
						} else {
							newTag.setAttribute("href", "/resources/images/view/db/db0103/lineOrange.gif");
						}
					});
					gifImg.outerHTML = newTag.outerHTML;
				});

				[...emtSvg.querySelector("#RightGrpBottom #RightGrpBottomBg-hover").children].forEach(hoverEmt => {
					hoverEmt.classList.add("right-grp-bottom-bg");
				});

				emtSvg.querySelectorAll("#LeftGrp g[id^='data'][id$='Img'] > [id*='Img-']").forEach(emt => {
					emt.addEventListener("mouseenter", function() {
						if (!dataObj.isEvent) {
							dataObj.isEvent = true;
							emtSvg.querySelectorAll("#LeftGrp #" + emt.parentElement.id + " > g[id*='Img-NameTag0']").forEach(nameTag => {
								let imgBg = emtSvg.querySelector("#LeftGrp #" + emt.parentElement.id + " > [id*='Img-Bg']");
								imgBg.classList.add("left-grp-img-bg-hover");
								nameTag.classList.remove("display-none");

								[...emtSvg.querySelector("#RightGrpBottom #RightGrpBottomBg-hover").children].forEach(hoverEmt => {
									if (hoverEmt.id != emt.id.split("-")[0].replace("grpD", "d").replace("data05", "data04") + "-hover") {
										hoverEmt.classList.add("filter-brightness");
									} else {
										hoverEmt.classList.add("right-grp-bottom-bg-hover");
									}
								});
								let rightBottomBg = emtSvg.querySelector("#RightGrpBottom #RightGrpBottomBg");
								if (rightBottomBg) {
									rightBottomBg.classList.add("filter-brightness");
								}

								emtSvg.querySelectorAll("#RightGrpBottom #RightGrpBottom-Tooltip > text").forEach(emtText => {
									if (dataObj.tooltipText[emt.id.split("-")[0].replace("grpD", "d")] != undefined) {
										if (dataObj.tooltipText[emt.id.split("-")[0].replace("grpD", "d")][emtText.id.split("-")[1]] != undefined) {
											let tspanEmt = emtText.querySelector("tspan");
											if (tspanEmt) {
												tspanEmt.innerHTML = dataObj.tooltipText[emt.id.split("-")[0].replace("grpD", "d")][emtText.id.split("-")[1]];
											}
										}
									}
								});
								let bottomToolTip = emtSvg.querySelector("#RightGrpBottom #RightGrpBottom-Tooltip");
								if (bottomToolTip) {
									bottomToolTip.classList.remove("display-none");
								}
							});
							setTimeout(() => {
								dataObj.isEvent = false;
							}, dataObj.eventTime);
						}
					});
					emt.addEventListener("mouseleave", function() {
						emtSvg.querySelectorAll("#LeftGrp #" + emt.parentElement.id + " > g[id*='Img-NameTag0']").forEach(nameTag => {
							let imgBg = emtSvg.querySelector("#LeftGrp #" + emt.parentElement.id + " > [id*='Img-Bg']");
							imgBg.classList.remove("left-grp-img-bg-hover");
							nameTag.classList.add("display-none");
							emtSvg.querySelectorAll("#RightGrpBottom .filter-brightness").forEach(brightList => {
								brightList.classList.remove("filter-brightness");
							});
							emtSvg.querySelectorAll("#RightGrpBottom .right-grp-bottom-bg-hover").forEach(hoverList => {
								hoverList.classList.remove("right-grp-bottom-bg-hover");
							});
							let bottomToolTip = emtSvg.querySelector("#RightGrpBottom #RightGrpBottom-Tooltip");
							if (bottomToolTip) {
								bottomToolTip.classList.add("display-none");
							}
						});
					});
				});

				// 데이터 어트리뷰트 셋팅
				setDataAtt(dataObj.tagMapping, emtSvg);

				// 데이터 바인딩
				let ajaxDataFunc = () => {
					ajaxData(Object.values(dataObj.tagMapping)).then((res) => {
						if (res) {
							// 평면도 펌프 아이콘 상태 초기화 (새 데이터 처리 전에 OFF로 설정)
							emtSvg.querySelectorAll("#grpRightGrpTopTooltipIcons > g[id^='topTooltipIcon-']").forEach(iconEmt => {
								iconEmt.setAttribute("data-onoff", "OFF");
								iconEmt.querySelectorAll("[id^='topTooltipIcon'] > :not([id^='topTooltipIcon']):last-child").forEach(emtColors => {
									let preEmt = emtColors.previousElementSibling;
									emtColors.classList.remove("display-none");
									if (preEmt.tagName && preEmt.tagName.toLowerCase() == "circle") {
										preEmt.classList.add("display-none");
									}
								});
							});
							res.param.forEach(item => {
								let emts = emtSvg.querySelectorAll("[data-tag='" + item.name + "']");
								if (emts.length == 0) {
									emts = emtSvg.querySelectorAll("[data-tag*='" + item.name + "']");
								}
								emts.forEach(emt => {
									if (emt.tagName && (emt.tagName.toLowerCase() == "tspan" || emt.tagName.toLowerCase() == "span")) {
										let isDefault = true;
										let preText = emt.textContent;
										let itemVal = item.val;
										if (itemVal != null) {
											if (String(itemVal).includes(",")) {
												if (String(itemVal).toLowerCase().startsWith("sum::") ||
													String(itemVal).toLowerCase().startsWith("max::") ||
													String(itemVal).toLowerCase().startsWith("min::") ||
													String(itemVal).toLowerCase().startsWith("or::") ||
													String(itemVal).toLowerCase().startsWith("and::")) {
													isDefault = false;
													let resultData = calcData(itemVal);
													resultData = Number(resultData).toLocaleString("ko-KR");
													if (preText != resultData) {
														emt.textContent = resultData;
													}
												}
											}
										}

										if (isDefault) {
											emt.textContent = itemVal;
										}
									} else if (emt.tagName && emt.tagName.toLowerCase() == "g") {
										let onOffData = Number(item.val) == 0 ? false : true;
										if (onOffData) {
											emt.setAttribute("data-onoff", "ON");
											emt.querySelectorAll("[id^='topTooltipIcon'] > :not([id^='topTooltipIcon']):last-child").forEach(emtColors => {
												let preEmt = emtColors.previousElementSibling;
												emtColors.classList.add("display-none");
												if (preEmt.tagName && preEmt.tagName.toLowerCase() == "circle") {
													preEmt.classList.remove("display-none");
												}
											});
										} else if (emt.getAttribute("data-onoff") !== "ON") {
											// 이미 ON으로 설정되어 있으면 OFF로 변경하지 않음
											emt.querySelectorAll("[id^='topTooltipIcon'] > :not([id^='topTooltipIcon']):last-child").forEach(emtColors => {
												let preEmt = emtColors.previousElementSibling;
												emtColors.classList.remove("display-none");
												if (preEmt.tagName && preEmt.tagName.toLowerCase() == "circle") {
													preEmt.classList.add("display-none");
												}
											});
										}
									}
								});
							});

							let tooltipData = {
								"data01Img" : {
									"TooltipText01" : {
										"{data1}" : (Math.floor(Math.random() * (20000 - 100 + 1)) + 100).toLocaleString("ko-KR"),
										"{data2}" : (Math.floor(Math.random() * ((20000 * 24) - (100 * 24) + 1)) + (100 * 24)).toLocaleString("ko-KR")
									},
									"TooltipText02" : {
										"{data1}" : (Math.round(((Math.random() * (10 - 0.1 + 1)) + 0.1) * 10) / 10).toLocaleString("ko-KR")
									},
									"TooltipText03" : {
										"{data1}" : (Math.round(((Math.random() * (10 - 0.1 + 1)) + 0.1) * 100) / 100).toLocaleString("ko-KR"),
									}
								}
							};
							const regex = /\{data\d+\}/g;
							Object.keys(dataObj.tooltipText).forEach(outerKey => {
								Object.keys(dataObj.tooltipText[outerKey]).forEach(innerKey => {
									let tooltipText = dataObj.tooltipText[outerKey][innerKey];
									if (regex.test(tooltipText)) {
										tooltipText.match(regex).forEach(textData => {
											dataObj.tooltipText[outerKey][innerKey] = dataObj.tooltipText[outerKey][innerKey].replace(textData, tooltipData[outerKey][innerKey][textData]);
										});
									}
								});
							});
						}
					});
				};
				timeOutData(ajaxDataFunc);

				$("#contents").html(emtSvg);
			});
		};

		/* 공정도 */
		function loadProcessChart() {
			dataObj.tagMapping = {
				"topGrpSymbol-obj-01-off" : "CDSWSS.M116A_FO_STS.F_CV,CDSWSS.M116B_FO_STS.F_CV,CDSWSS.M116C_FO_STS.F_CV",
				"topGrpSymbol-obj-02-off" : "CDSWSS.M106A_RUN_STS.F_CV,CDSWSS.M106B_RUN_STS.F_CV,CDSWSS.M106C_RUN_STS.F_CV",
				"topGrpSymbol-obj-03-off" : "CDSWSS.M111A_FO_STS.F_CV,CDSWSS.M111B_FO_STS.F_CV",
				"topGrpSymbol-obj-04-off" : "CDSWSS.DAF_01_INSER_MODE.F_CV,CDSWSS.DAF_02_INSER_MODE.F_CV,CDSWSS.DAF_03_INSER_MODE.F_CV,CDSWSS.DAF_04_INSER_MODE.F_CV,CDSWSS.DAF_05_INSER_MODE.F_CV",
				"topGrpSymbol-obj-05-off" : "CDSWSS.DMGF_A_ON_ST.F_CV,CDSWSS.DMGF_B_ON_ST.F_CV,CDSWSS.DMGF_C_ON_ST.F_CV,CDSWSS.DMGF_D_ON_ST.F_CV,CDSWSS.DMGF_E_ON_ST.F_CV,CDSWSS.DMGF_F_ON_ST.F_CV,CDSWSS.DMGF_H_ON_ST.F_CV,CDSWSS.DMGF_I_ON_ST.F_CV,CDSWSS.DMGF_J_ON_ST.F_CV,CDSWSS.DMGF_K_ON_ST.F_CV,CDSWSS.DMGF_L_ON_ST.F_CV,CDSWSS.DMGF_M_ON_ST.F_CV,CDSWSS.DMGF_N_ON_MODE.F_CV",
				"topGrpSymbol-obj-06-off" : "CDSWSS.SWRO_A_RUN_STS.F_CV,CDSWSS.SWRO_B_RUN_STS.F_CV,CDSWSS.SWRO_C_RUN_STS.F_CV,CDSWSS.SWRO_D_RUN_STS.F_CV,CDSWSS.SWRO_E_RUN_STS.F_CV,CDSWSS.SWRO_F_RUN_STS.F_CV", 
				"topGrpSymbol-obj-07-off" : "CDSWSS.BWRO_A_RUN_STS.F_CV,CDSWSS.BWRO_B_RUN_STS.F_CV,CDSWSS.BWRO_C_RUN_STS.F_CV,CDSWSS.BWRO_D_RUN_STS.F_CV,CDSWSS.BWRO_E_RUN_STS.F_CV,CDSWSS.BWRO_F_RUN_STS.F_CV",
				"topGrpSymbol-obj-08-off" : "CDSWSS.M448A_FO_STS.F_CV,CDSWSS.M448B_FO_STS.F_CV",
				"topGrpSymbol-obj-09-off" : "CDSWSS.M416A_FO_STS.F_CV,CDSWSS.M416B_FO_STS.F_CV,CDSWSS.M416C_FO_STS.F_CV,CDSWSS.M416D_FO_STS.F_CV,CDSWSS.M416E_FO_STS.F_CV,CDSWSS.M416F_FO_STS.F_CV",
				"bottomGrpData-01-datas-01" : "CDSWSS.LIT201_AVG.F_CV",
				"bottomGrpData-01-datas-02" : "CDSWSS.SP_SWIP_FWL.F_CV",
				"bottomGrpData-01-datas-03" : "CDSWSS.FIT101.F_CV",
				"bottomGrpData-02-datas-01" : "CDSWSS.FIT201.F_CV",
				"bottomGrpData-02-datas-02" : "CDSWSS.PIT104.F_CV",
				"bottomGrpData-02-datas-03" : "CDSWSS.LIT201A.F_CV",
				"bottomGrpData-02-datas-04" : "CDSWSS.LIT201B.F_CV",
				"bottomGrpData-03-datas-01" : "CDSWSS.FIT202.F_CV",
				"bottomGrpData-03-datas-02" : "CDSWSS.PIT201.F_CV",
				"bottomGrpData-03-datas-03" : "CDSWSS.LIT202.F_CV",
				"bottomGrpData-04-datas-01" : "CDSWSS.FIT301.F_CV",
				"bottomGrpData-04-datas-02" : "CDSWSS.PIT301.F_CV",
				"bottomGrpData-04-datas-03" : "CDSWSS.LIT321A.F_CV",
				"bottomGrpData-04-datas-04" : "CDSWSS.LIT321B.F_CV",
				"bottomGrpData-05-datas-01" : "CDSWSS.FIT413S.F_CV",
				"bottomGrpData-05-datas-02" : "CDSWSS.FIT414S.F_CV",
				"bottomGrpData-06-datas-01" : "SUM(CDSWSS.FIT411S.F_CV,CDSWSS.FIT421S.F_CV,CDSWSS.FIT431S.F_CV,CDSWSS.FIT441S.F_CV,CDSWSS.FIT451S.F_CV,CDSWSS.FIT461S.F_CV)",
				"bottomGrpData-06-datas-02" : "SUM(CDSWSS.FIT412S.F_CV,CDSWSS.FIT422S.F_CV,CDSWSS.FIT432S.F_CV,CDSWSS.FIT442S.F_CV,CDSWSS.FIT452S.F_CV,CDSWSS.FIT462S.F_CV)",
				"bottomGrpData-07-datas-01" : "SUM(CDSWSS.FIT411B.F_CV,CDSWSS.FIT421B.F_CV,CDSWSS.FIT431B.F_CV,CDSWSS.FIT441B.F_CV,CDSWSS.FIT451B.F_CV,CDSWSS.FIT461B.F_CV)",
				"bottomGrpData-07-datas-02" : "SUM(CDSWSS.FIT412B.F_CV,CDSWSS.FIT422B.F_CV,CDSWSS.FIT432B.F_CV,CDSWSS.FIT442B.F_CV,CDSWSS.FIT452B.F_CV,CDSWSS.FIT462B.F_CV)",
				"bottomGrpData-07-datas-03" : "SUM(CDSWSS.FIT413B.F_CV,CDSWSS.FIT423B.F_CV,CDSWSS.FIT433B.F_CV,CDSWSS.FIT443B.F_CV,CDSWSS.FIT453B.F_CV,CDSWSS.FIT463B.F_CV)",
				"bottomGrpData-08-datas-01" : "CDSWSS.FIT482.F_CV",
				"bottomGrpData-08-datas-02" : "CDSWSS.PIT482.F_CV",
				"bottomGrpData-08-datas-03" : "CDSWSS.LIT481A.F_CV",
				"bottomGrpData-08-datas-04" : "CDSWSS.LIT481B.F_CV",
			};

			ajaxImg("processChart.svg").then((emtSvg) => {
				let bottomGrpData02 = emtSvg.querySelector("#bottomGrp > #bottomGrpDatas > #bottomGrpData-02");
				if (bottomGrpData02) {
					bottomGrpData02.innerHTML = bottomGrpData02.innerHTML.replace("rect", "foreignObject");
					let emtForeignObject = bottomGrpData02.querySelector("#bottomGrpData-02-obj");
					emtForeignObject.removeAttribute("fill");
					emtForeignObject.removeAttribute("fill-opacity");

					let emtDiv = document.createElement("div");
					emtDiv.setAttribute("xmlns", "http://www.w3.org/1999/xhtml");
					emtDiv.classList.add("process-chart-bottom-data");

					const contentsText = {
						"취수설비": ["현재 수위", "m", "목표 수위", "m", "약품주입량", "㎥/h"],
						"원수저류조": ["유입 유량", "㎥/h", "유입 압력", "㎏/㎠", "수위", ["m", "m"]],
						"전전처리": ["유입 유량", "㎥/h", "유입 압력", "㎏/㎠", "수위", "m"],
						"전처리": ["유입 유량", "㎥/h", "유입 압력", "㎏/㎠", "여과수저류조 수위", ["m", "m"]],
						"에너지 회수장치": ["유입 유량", "㎥/h", "유입 압력", "㎏/㎠", "", ""],
						"SWRO": ["유입 유량", "㎥/h", "유출 유량", "㎥/h", "", ""],
						"BWRO": ["유입 유량", "㎥/h", "1단 유출 유량", "㎥/h", "2단 유출 유량", "㎥/h"],
						"생산수조": ["유출 유량", "㎥/h", "유출 압력", "㎏/㎠", "수위", ["m", "m"]],
					};
					Object.keys(contentsText).forEach((text, idx1) => {
						let emtIdx = 1;
						let emtContentDiv = document.createElement("div");
						emtContentDiv.id = "process-chart-bottom-data-content-" + String(idx1 + 1).padStart(2, "0");
						emtContentDiv.classList.add("process-chart-bottom-data-contents");
						for (let idx2 = 0; idx2 <= contentsText[Object.keys(contentsText)[0]].length; idx2++) {
							let emtDataDiv = document.createElement("div");
							emtDataDiv.id = "process-chart-bottom-data-content-" + String(idx1 + 1).padStart(2, "0") + "-data-" + String(idx2 + 1).padStart(2, "0");
							emtDataDiv.classList.add("process-chart-bottom-data-content-datas");
							let dataContent = contentsText[text][(idx2 - 1)];

							let createSpanFunc = function(_idx2, _text, _dataContent, _emtDataDiv) {
								let emtTextSpan = document.createElement("span");
								let emtDataSpan = null;
								if (_idx2 == 0) {
									_emtDataDiv.style.fontSize = "1.5rem";
									emtTextSpan.textContent = _text;
								} else {
									if (_idx2 !=0 && (_idx2 % 2) == 1) {
										_emtDataDiv.style.color = "#BFBFBF";
									} else {
										emtTextSpan.classList.add("process-chart-bottom-data-content-units");
										emtDataSpan = document.createElement("span");
										emtDataSpan.id = "bottomGrpData-" + String(idx1 + 1).padStart(2, "0") + "-datas-" + String(emtIdx++).padStart(2, "0");
										emtDataSpan.classList.add("process-chart-bottom-data-content-data");
										if (_dataContent) {
											emtDataSpan.textContent = "-";
										}
									}
									emtTextSpan.textContent = _dataContent;
								}
								if (emtDataSpan) {
									_emtDataDiv.appendChild(emtDataSpan);
								}
								_emtDataDiv.appendChild(emtTextSpan);
							};
							if (Array.isArray(dataContent)) {
								emtDataDiv.classList.add("process-chart-bottom-data-content-datas-flex");
								dataContent.forEach(innerDataContent => {
									let emtDataInnerDiv = document.createElement("div");
									emtDataInnerDiv.classList.add("process-chart-bottom-data-content-datas-inner");
									createSpanFunc(idx2, text, innerDataContent, emtDataInnerDiv);
									emtDataDiv.appendChild(emtDataInnerDiv);
								});
							} else {
								createSpanFunc(idx2, text, dataContent, emtDataDiv);
							}
							emtContentDiv.appendChild(emtDataDiv);
						}
						emtDiv.appendChild(emtContentDiv);
					});

					emtForeignObject.appendChild(emtDiv);
					bottomGrpData02.appendChild(emtForeignObject);
					bottomGrpData02.classList.add("display-none");
				}

				emtSvg.querySelectorAll("#topGrp > #topGrpTooltip > #topGrpSymbol-tooltips > g[id^='topGrpSymbol-tooltip-']").forEach(emtTooltip => {
					emtTooltip.classList.add("display-none");
				});
				emtSvg.querySelectorAll("#topGrp > #topGrpTooltip > #topGrpData-tooltips > g[id^='topGrpData-tooltip-']").forEach(emtTooltip => {
					emtTooltip.classList.add("display-none");
				});

				emtSvg.querySelectorAll("#topGrp > #topGrpSymbol > #topGrpSymbol-gifs > [id^='topGrpSymbol-gif-']").forEach(gifImg => {
					let newTag = document.createElement("image");
					newTag.classList.add("gif-simbol-img");
					gifImg.getAttributeNames().forEach(attr => {
						if (attr != "fill") {
							newTag.setAttribute(attr, gifImg.getAttribute(attr));
						} else {
							if (gifImg.getAttribute("width") == "160") {
								newTag.setAttribute("href", "/resources/images/view/db/db0103/line(160).gif");
							} else if (gifImg.getAttribute("width") == "120") {
								newTag.setAttribute("href", "/resources/images/view/db/db0103/line(120).gif");
							}
						}
					});
					gifImg.outerHTML = newTag.outerHTML;
				});

				let objEvent = function(emtTarget, replaceText) {
					let emtTooltip = emtSvg.querySelector("#topGrp > #topGrpTooltip > #topGrpSymbol-tooltips > #" + emtTarget.id.replace("-on", "").replace("-off", "").replace(replaceText, "tooltip"));
					if (emtTooltip) {
						emtTarget.addEventListener("mouseenter", function() {
							if (!dataObj.isEvent) {
								dataObj.isEvent = true;
								emtTooltip.classList.remove("display-none");
								setTimeout(() => {
									dataObj.isEvent = false;
								}, dataObj.eventTime);
							}
						});
						emtTarget.addEventListener("mouseleave", function() {
							emtTooltip.classList.add("display-none");
						});
					}
					emtTarget.addEventListener("click", function() {
						let popupName = this.getAttribute("data-popup");
						if (popupName) {
							showPop(popupName, "width=1810, height=945, top=130, left=20, resizable=no ,scrollbars=no, status=no, location=no");
						}
					});
				};

				const popupMapping = {
					"01" : "CS",
					"02" : "CS",
					"03" : "WJ",
					"04" : "DAF",
					"05" : "DMGF",
					"06" : "RO",
					"07" : "RO",
					"08" : "SJ",
				};

				emtSvg.querySelectorAll("#topGrp > #topGrpSymbol > #topGrpSymbol-texts > [id^='topGrpSymbol-text']").forEach((emtText, idx) => {
					if (idx != 8 && idx != 8 * 2) {
						emtText.setAttribute("data-popup", popupMapping[emtText.id.slice(-2)]);
						emtText.classList.add("clickable");
						objEvent(emtText, "text")
					}
				});

				emtSvg.querySelectorAll("#topGrp > #topGrpSymbol > #topGrpSymbol-objs > [id^='topGrpSymbol-obj']").forEach((emtObj, idx) => {
					if (idx != 8 && idx != 17) {
						emtObj.setAttribute("data-popup", popupMapping[emtObj.id.replace("-on", "").replace("-off", "").slice(-2)]);
						emtObj.classList.add("clickable");
						objEvent(emtObj, "obj")
					}
				});

				emtSvg.querySelectorAll("#topGrp > #topGrpData > #topGrpData-imgs > [id^='topGrpData-img-']").forEach((emtImg, idx) => {
					if (idx != 0) {
						emtImg.classList.add("clickable");
						let emtTooltip = emtSvg.querySelector("#topGrp > #topGrpTooltip > #topGrpData-tooltips > #" + emtImg.id.replace("img", "tooltip"));
						if (emtTooltip) {
							emtImg.addEventListener("mouseenter", function() {
								if (!dataObj.isEvent) {
									dataObj.isEvent = true;
									emtTooltip.classList.remove("display-none");
									setTimeout(() => {
										dataObj.isEvent = false;
									}, dataObj.eventTime);
								}
							});
							emtImg.addEventListener("mouseleave", function() {
								emtTooltip.classList.add("display-none");
							});
						}
					}
				});

				emtSvg.querySelectorAll("#bottomGrp > #bottomGrpBtns > g[id^='bottomGrpBtn-']").forEach(emtBtn => {
					emtBtn.classList.add("clickable");
					emtBtn.addEventListener("click", function() {
						emtSvg.querySelectorAll("#bottomGrp > #bottomGrpBtns > g[id^='bottomGrpBtn-']").forEach(emtBtnEvent => {
							let emtBtnBg = emtBtnEvent.querySelector("#" + emtBtnEvent.id + "-bg");
							let emtBtnText = emtBtnEvent.querySelector("#" + emtBtnEvent.id + "-text");
							let emtData = emtSvg.querySelector("#bottomGrp > #bottomGrpDatas > #" + emtBtnEvent.id.replace("Btn", "Data"));
							if (emtBtnEvent.id != emtBtn.id) {
								if (emtBtnBg) {
									emtBtnBg.setAttribute("y", "531.5");
									emtBtnBg.setAttribute("width", "65");
									emtBtnBg.setAttribute("height", "26");
									emtBtnBg.setAttribute("rx", "2.5");
									emtBtnBg.setAttribute("fill", "#FFFFFF");
									emtBtnBg.setAttribute("fill-opacity", "0.1");
									emtBtnBg.setAttribute("stroke", "#7ACDFF");
								}
								if (emtBtnText) {
									emtBtnText.setAttribute("fill", "#7ACDFF");
								}
								if (emtData) {
									emtData.classList.add("display-none");
								}
							} else {
								if (emtBtnBg) {
									emtBtnBg.setAttribute("y", "531");
									emtBtnBg.setAttribute("width", "66");
									emtBtnBg.setAttribute("height", "27");
									emtBtnBg.setAttribute("rx", "3");
									emtBtnBg.setAttribute("fill", "#128AD2");
									emtBtnBg.setAttribute("fill-opacity", "");
									emtBtnBg.setAttribute("stroke", "");
								}
								if (emtBtnText) {
									emtBtnText.setAttribute("fill", "#FFFFFF");
								}
								if (emtData) {
									emtData.classList.remove("display-none");
								}
							}
						});
					});
				});

				// 데이터 어트리뷰트 셋팅
				setDataAtt(dataObj.tagMapping, emtSvg);

				let ajaxDataFunc = () => {
					ajaxData(Object.values(dataObj.tagMapping)).then((res) => {
						if (res) {
							// 공정도 설비 상태 초기화 (새 데이터 처리 전에 OFF로 설정)
							emtSvg.querySelectorAll("#topGrp > #topGrpSymbol > #topGrpSymbol-objs > g[id$='-off']").forEach(offEmt => {
								offEmt.setAttribute("data-onoff", "OFF");
								offEmt.classList.remove("display-none");
								let onEmt = emtSvg.querySelector("#" + offEmt.id.replace("-off", "-on"));
								if (onEmt) {
									onEmt.classList.add("display-none");
								}
							});
							res.param.forEach(item => {
								let emts = emtSvg.querySelectorAll("[data-tag='" + item.name + "']");
								if (emts.length == 0) {
									emts = emtSvg.querySelectorAll("[data-tag*='" + item.name + "']");
								}
								emts.forEach(emt => {
									if (emt.tagName && (emt.tagName.toLowerCase() == "tspan" || emt.tagName.toLowerCase() == "span")) {
										let isDefault = true;
										let preText = emt.textContent;
										let itemVal = item.val;
										if (itemVal != null) {
											if (String(itemVal).includes(",")) {
												if (String(itemVal).toLowerCase().startsWith("sum::") ||
													String(itemVal).toLowerCase().startsWith("max::") ||
													String(itemVal).toLowerCase().startsWith("min::") ||
													String(itemVal).toLowerCase().startsWith("or::") ||
													String(itemVal).toLowerCase().startsWith("and::")) {
													isDefault = false;
													let resultData = calcData(itemVal);
													resultData = Number(resultData).toLocaleString("ko-KR");
													if (preText != resultData) {
														emt.textContent = resultData;
													}
												}
											}
										}

										if (isDefault) {
											emt.textContent = itemVal;
										}
									} else if (emt.tagName && emt.tagName.toLowerCase() == "g") {
										let onOffData = false;
										let itemVal = item.val;
										if (itemVal != null) {
											if (String(itemVal).includes(",")) {
												let splited = String(itemVal).split(",");
												splited.forEach(splitedItem => {
													onOffData = onOffData || Number(splitedItem) == 1;
												});
											} else {
												onOffData = onOffData || Number(itemVal) == 1;
											}
										}
										let otherEmt = emtSvg.querySelector("#topGrp > #topGrpSymbol > #topGrpSymbol-objs > #" + emt.id.replace("-off", "-on"));
										
										if (onOffData) {
											emt.setAttribute("data-onoff", "ON");
											emt.classList.add("display-none");
											otherEmt.classList.remove("display-none");
										} else if (emt.getAttribute("data-onoff") !== "ON") {
											// 이미 ON으로 설정되어 있으면 OFF로 변경하지 않음 (하나라도 실행 중이면 색 유지)
											emt.classList.remove("display-none");
											otherEmt.classList.add("display-none");
										}
									}
								});
							});
						}
					});
				};
				timeOutData(ajaxDataFunc);

				$("#contents").html(emtSvg);
			});
		};

		/* 계통도 */
		function loadSystematicDiagram() {
			dataObj.tagMapping = {
				"systematic-diagram-table-01-01" : "CDSWSS.FIT201.F_CV",
				"systematic-diagram-table-01-02" : "CDSWSS.FIT301.F_CV",
				"systematic-diagram-table-01-03" : "CDSWSS.FIT324.F_CV",
				"systematic-diagram-table-01-04" : "CDSWSS.FIT412S.F_CV",
				"systematic-diagram-table-01-05" : "CDSWSS.FIT412B.F_CV",
				"systematic-diagram-table-01-06" : "CDSWSS.FIT482.F_CV",
				"systematic-diagram-table-01-07" : "CDSWSS.FIT651.F_CV",
				"systematic-diagram-table-01-08" : "CDSWSS.FIT801.F_CV",
				"systematic-diagram-table-02-01" : "CDSWSS.PH101.F_CV",
				"systematic-diagram-table-02-02" : "CDSWSS.PH301.F_CV",
				"systematic-diagram-table-02-03" : "CDSWSS.PH301.F_CV",
				"systematic-diagram-table-02-04" : "CDSWSS.PH411S.F_CV",
				"systematic-diagram-table-02-05" : "CDSWSS.PH411B.F_CV",
				"systematic-diagram-table-02-06" : "CDSWSS.PH482.F_CV",
				"systematic-diagram-table-02-07" : "CDSWSS.PH703A.F_CV",
				"systematic-diagram-table-02-08" : "CDSWSS.PH671.F_CV",
				"systematic-diagram-table-03-01" : "CDSWSS.M106A_RUN_STS.F_CV,CDSWSS.M106B_RUN_STS.F_CV,CDSWSS.M106C_RUN_STS.F_CV",
				"systematic-diagram-table-03-02" : "CDSWSS.DAF_01_INSER_MODE.F_CV,CDSWSS.DAF_02_INSER_MODE.F_CV,CDSWSS.DAF_03_INSER_MODE.F_CV,CDSWSS.DAF_04_INSER_MODE.F_CV,CDSWSS.DAF_05_INSER_MODE.F_CV",
				"systematic-diagram-table-03-03" : "CDSWSS.DMGF_A_ON_ST.F_CV,CDSWSS.DMGF_B_ON_ST.F_CV,CDSWSS.DMGF_C_ON_ST.F_CV,CDSWSS.DMGF_D_ON_ST.F_CV,CDSWSS.DMGF_E_ON_ST.F_CV,CDSWSS.DMGF_F_ON_ST.F_CV,CDSWSS.DMGF_H_ON_ST.F_CV,CDSWSS.DMGF_I_ON_ST.F_CV,CDSWSS.DMGF_J_ON_ST.F_CV,CDSWSS.DMGF_K_ON_ST.F_CV,CDSWSS.DMGF_L_ON_ST.F_CV,CDSWSS.DMGF_M_ON_ST.F_CV,CDSWSS.DMGF_N_ON_MODE.F_CV",
				"systematic-diagram-table-03-04" : "CDSWSS.SWRO_A_RUN_STS.F_CV,CDSWSS.SWRO_B_RUN_STS.F_CV,CDSWSS.SWRO_C_RUN_STS.F_CV,CDSWSS.SWRO_D_RUN_STS.F_CV,CDSWSS.SWRO_E_RUN_STS.F_CV,CDSWSS.SWRO_F_RUN_STS.F_CV",
				"systematic-diagram-table-03-05" : "CDSWSS.BWRO_A_RUN_STS.F_CV,CDSWSS.BWRO_B_RUN_STS.F_CV,CDSWSS.BWRO_C_RUN_STS.F_CV,CDSWSS.BWRO_D_RUN_STS.F_CV,CDSWSS.BWRO_E_RUN_STS.F_CV,CDSWSS.BWRO_F_RUN_STS.F_CV",
				"systematic-diagram-table-03-06" : "CDSWSS.M448A_FO_STS.F_CV,CDSWSS.M448B_FO_STS.F_CV",
				"systematic-diagram-table-03-07" : "CDSWSS.M702A_RUN_STS.F_CV,CDSWSS.M702B_RUN_STS.F_CV,CDSWSS.M702C_RUN_STS.F_CV",
				"systematic-diagram-table-03-08" : "CDSWSS.M714A_RUN_STS.F_CV,CDSWSS.M714B_RUN_STS.F_CV",
				"pump01OnOff-01" : "CDSWSS.M106A_RUN_STS.F_CV",
				"pump01OnOff-02" : "CDSWSS.M106B_RUN_STS.F_CV",
				"pump01OnOff-03" : "CDSWSS.M106C_RUN_STS.F_CV",
				"pump02OnOff-01" : "CDSWSS.M403A_RUN_STS.F_CV",
				"pump02OnOff-02" : "CDSWSS.M403B_RUN_STS.F_CV",
				"pump02OnOff-03" : "CDSWSS.M403C_RUN_STS.F_CV",
				"pump02OnOff-04" : "CDSWSS.M403D_RUN_STS.F_CV",
				"pump02OnOff-05" : "CDSWSS.M403E_RUN_STS.F_CV",
				"pump02OnOff-06" : "CDSWSS.M403F_RUN_STS.F_CV",
				"pump03OnOff-01" : "CDSWSS.M404A_RUN_STS.F_CV",
				"pump03OnOff-02" : "CDSWSS.M404B_RUN_STS.F_CV",
				"pump03OnOff-03" : "CDSWSS.M404C_RUN_STS.F_CV",
				"pump03OnOff-04" : "CDSWSS.M404D_RUN_STS.F_CV",
				"pump03OnOff-05" : "CDSWSS.M404E_RUN_STS.F_CV",
				"pump03OnOff-06" : "CDSWSS.M404F_RUN_STS.F_CV",
				"pump04OnOff-01" : "CDSWSS.M407A_RUN_STS.F_CV",
				"pump04OnOff-02" : "CDSWSS.M407B_RUN_STS.F_CV",
				"pump04OnOff-03" : "CDSWSS.M407C_RUN_STS.F_CV",
				"pump04OnOff-04" : "CDSWSS.M407D_RUN_STS.F_CV",
				"pump04OnOff-05" : "CDSWSS.M407E_RUN_STS.F_CV",
				"pump04OnOff-06" : "CDSWSS.M407F_RUN_STS.F_CV",
				"pump05OnOff-01" : "CDSWSS.M721A_RUN_STS.F_CV",
				"pump05OnOff-02" : "CDSWSS.M721B_RUN_STS.F_CV",
				"pump05OnOff-03" : "CDSWSS.M721C_RUN_STS.F_CV",
				"pump06OnOff-01" : "CDSWSS.M714A_RUN_STS.F_CV",
				"pump06OnOff-02" : "CDSWSS.M714B_RUN_STS.F_CV",
				"pump07OnOff-01" : "CDSWSS.M802A_RUN_STS.F_CV",
				"pump07OnOff-02" : "CDSWSS.M802B_RUN_STS.F_CV",
				"pump07OnOff-03" : "CDSWSS.M802C_RUN_STS.F_CV",
				"pump07OnOff-04" : "CDSWSS.M802D_RUN_STS.F_CV",
			};

			// 하단 테이블
			let systematicDiagramContent = document.createElement("div");
			systematicDiagramContent.id = "systematicDiagramContent";

			let topContent = document.createElement("div");
			topContent.classList.add("systematic-diagram-top");

			let bottomContent = document.createElement("div");
			bottomContent.classList.add("systematic-diagram-bottom");

			let emtTable = document.createElement("table");
			emtTable.classList.add("systematic-diagram-bottom-table");

			const colHeaderText = ["구분", "취수설비", "DAF 운영", "DMGF 운영", "SW-RO", "BW-RO", "생산수조", "폐수처리", "방류수"];
			const rowHeaderText = ["유량", "수질", "가동여부"];
			// 테이블 헤더
			let emtThead = document.createElement("thead");
			let emtTr = document.createElement("tr");
			colHeaderText.forEach((text) => {
				let emtTh = document.createElement("th");
				emtTh.textContent = text;
				emtTr.appendChild(emtTh);
			});
			emtThead.appendChild(emtTr);
			emtTable.appendChild(emtThead);

			const hoverColMapping = [
				"nameTag01", "nameTag02", "nameTag03",
				"nameTag04", "nameTag05", "",
				"nameTag06", ""
			];
			let emtTbody = document.createElement("tbody");
			// 테이블 바디
			rowHeaderText.forEach((text, idx) => {
				emtTr = document.createElement("tr");
				let emtTd = document.createElement("td");
				emtTd.textContent = text;
				emtTr.appendChild(emtTd);
				for (let col = 1; col < colHeaderText.length ; col++) {
					emtTd = document.createElement("td");
					emtTd.classList.add("systematic-diagram-table-datas");

					let hoverClassNm = hoverColMapping[col - 1];
					if (hoverClassNm) {
						emtTd.classList.add(hoverClassNm + "Col");
					}
					let emtSpan = document.createElement("span");
					emtSpan.id = "systematic-diagram-table-" + String(idx + 1).padStart(2, "0") + "-" + String(col).padStart(2, "0");

					if (idx == rowHeaderText.length - 1) {
						emtSpan.textContent = "OFF";
					} else {
						emtSpan.textContent = "-";
					}
					emtTd.appendChild(emtSpan);
					emtTr.appendChild(emtTd);
				}
				emtTbody.appendChild(emtTr);
			});
			emtTable.appendChild(emtTbody);

			bottomContent.appendChild(emtTable);

			systematicDiagramContent.appendChild(topContent);
			systematicDiagramContent.appendChild(bottomContent);

			// SVG
			ajaxImg("systematicDiagram.svg").then((emtSvg) => {
				emtSvg.style.borderRadius = "0.5rem";
				topContent.append(emtSvg);

				// 툴팁
				[...emtSvg.querySelector("#grpPumpTooltip").children].forEach(emt => {
					emt.classList.add("display-none");
				});

				emtSvg.querySelectorAll("#grpPumpTooltip > g[id^='pump'][id$='Tooltip'] g[id^='pump'][id*='TooltipIcon'][id$='Icon'] > circle:first-child").forEach(emtCircle => {
					emtCircle.setAttribute("stroke-width", "2.5");
				});

				// 펌프
				[...emtSvg.querySelector("#grpPump").children].forEach(emt => {
					emt.classList.add("clickable");
					let emtId = emt.id;
					let emtTooltip = emtSvg.querySelector("#grpPumpTooltip #" + emtId.replace("Box", "Tooltip"));
					if (emtTooltip) {
						emt.addEventListener("mouseenter", function() {
							if (!dataObj.isEvent) {
								dataObj.isEvent = true;
								emtTooltip.classList.remove("display-none");
								setTimeout(() => {
									dataObj.isEvent = false;
								}, dataObj.eventTime);
							}
						});
						emt.addEventListener("mouseleave", function() {
							emtTooltip.classList.add("display-none");
						});
					}
				});

				const popupMapping = {
					"nameTag01" : "CS",
					"nameTag02" : "DAF",
					"nameTag03" : "DMGF",
					"nameTag04" : "RO",
					"nameTag05" : "RO",
					"nameTag06" : "PS",
					"nameTag07" : "PS",
				};

				// 네임태그
				[...emtSvg.querySelector("#grpNameTag").children].forEach(emt => {
					// 네임태그 호버영역
					emt.classList.add("clickable");
					let emtId = emt.id;
					emt.setAttribute("data-popup", popupMapping[emtId]);
					let emtHoverBg = emtSvg.querySelector("#grpHoverBg #" + emtId + "HoverBg");
					if (emtHoverBg) {
						emtHoverBg.classList.add("display-none");
						emt.addEventListener("mouseenter", function() {
							if (!dataObj.isEvent) {
								dataObj.isEvent = true;
								emtHoverBg.classList.remove("display-none");
								let emtHoverCols = systematicDiagramContent.querySelectorAll("#systematicDiagramContent ." + emtId + "Col");
								emtHoverCols.forEach((emtHoverCol) => {
									emtHoverCol.classList.add("table-col-hover");
								});
								setTimeout(() => {
									dataObj.isEvent = false;
								}, dataObj.eventTime);
							}
						});
						emt.addEventListener("mouseleave", function() {
							emtHoverBg.classList.add("display-none");
							let emtHoverCols = systematicDiagramContent.querySelectorAll("#systematicDiagramContent ." + emtId + "Col");
							emtHoverCols.forEach((emtHoverCol) => {
								emtHoverCol.classList.remove("table-col-hover");
							});
						});
					}
					emt.addEventListener("click", function() {
						let popupName = this.getAttribute("data-popup");
						if (popupName) {
							showPop(popupName, "width=1810, height=945, top=130, left=20, resizable=no ,scrollbars=no, status=no, location=no");
						}
					});
				});

				// 데이터 어트리뷰트 셋팅
				setDataAtt(dataObj.tagMapping, systematicDiagramContent);
				setDataAtt(dataObj.tagMapping, emtSvg);

				let ajaxDataFunc = () => {
					ajaxData(Object.values(dataObj.tagMapping)).then((res) => {
						if (res) {
							// 펌프 그룹 상태 초기화 (새 데이터 처리 전에 OFF로 설정)
							document.querySelectorAll("#grpPump > g[id$='Box']").forEach(pumpBox => {
								pumpBox.setAttribute("data-onoff", "OFF");
								let emtIconBg = document.querySelector("#" + pumpBox.id.replace("Box", "IconBgTop") + " [fill*='radial']");
								if (emtIconBg) {
									emtIconBg.classList.remove("display-none");
								}
							});
							res.param.forEach(item => {
								let emts = document.querySelectorAll("[data-tag='" + item.name + "']");
								if (emts.length == 0) {
									emts = document.querySelectorAll("[data-tag$='" + item.name + ")']");
									if (emts.length == 0) {
										emts = document.querySelectorAll("[data-tag*='" + item.name + "']");
									}
								}
								emts.forEach(emt => {
									let itemVal = item.val;
									if (emt.tagName && (emt.tagName.toLowerCase() == "tspan" || emt.tagName.toLowerCase() == "span")) {
										if (emt.id.startsWith("systematic-diagram-table-03-")) {
											let onOffData = false;
											if (itemVal != null) {
												if (String(itemVal).includes(",")) {
													let splited = String(itemVal).split(",");
													splited.forEach(splitedItem => {
														onOffData = onOffData || Number(splitedItem) >= 1;
													});
												} else {
													onOffData = onOffData || Number(itemVal) >= 1;
												}
											}
											emt.textContent = onOffData ? "ON" : "OFF";
											let className = ([...emt.parentElement.classList].find(classNm => classNm.startsWith("nameTag")) || "").replace("Col", "");
											if (className) {
												let emtNameTag = document.querySelector("#systematicDiagramContent #grpNameTag #" + className);
												if (emtNameTag) {
													let dataOnOff = emtNameTag.getAttribute("data-onoff") || "OFF";
													if (onOffData || (dataOnOff == "ON" ? true : false)) {
														emtNameTag.setAttribute("data-onoff", "ON");
													} else {
														emtNameTag.setAttribute("data-onoff", "OFF");
													}
												}
											}
										} else {
											let preText = emt.textContent;
											if (itemVal != null) {
												if (preText != itemVal.toLocaleString("ko-KR")) {
													emt.textContent = itemVal.toLocaleString("ko-KR");
												}
											} else {
												emt.textContent = itemVal;
											}
										}
									} else if (emt.tagName && (emt.tagName.toLowerCase() == "g" || emt.tagName.toLowerCase() == "circle")) {
										let onOffData = false;
										if (itemVal != null) {
											if (String(itemVal).includes(",")) {
												let splited = String(itemVal).split(",");
												splited.forEach(splitedItem => {
													onOffData = onOffData || Number(splitedItem) >= 1;
												});
											} else {
												onOffData = onOffData || Number(itemVal) >= 1;
											}
										}
										// itemVal이 null이어도 onOffData는 false로 처리
										emt.setAttribute("data-onoff", onOffData ? "ON" : "OFF");
										// 펌프 점 색상 직접 변경 (CSS보다 SVG 인라인 속성이 우선하므로)
										if (onOffData) {
											emt.setAttribute("fill", "#2ECCEF");
											emt.setAttribute("fill-opacity", "1");
											emt.setAttribute("stroke", "#2ECCEF");
										} else {
											emt.setAttribute("fill", "#D9D9D9");
											emt.setAttribute("fill-opacity", "0.3");
											emt.setAttribute("stroke", "#D9D9D9");
										}
										let emtTooltipIcon = document.querySelector("#grpPumpTooltip #" + emt.id.replace("OnOff", "TooltipIcon"));
										if (emtTooltipIcon) {
											emtTooltipIcon.querySelectorAll("[id^='pump'] > :not([id^='pump']):last-child").forEach(emtColors => {
												let preEmt = emtColors.previousElementSibling;
												if (onOffData) {
													emtColors.classList.add("display-none");
													if (preEmt.tagName && preEmt.tagName.toLowerCase() == "circle") {
														preEmt.classList.remove("display-none");
													}
												} else {
													emtColors.classList.remove("display-none");
													if (preEmt.tagName && preEmt.tagName.toLowerCase() == "circle") {
														preEmt.classList.add("display-none");
													}
												}
											});
										}

										let prantEmt = emt.parentElement;
										let emtIconBg = document.querySelector("#" + prantEmt.id.replace("Box", "IconBgTop") + " [fill*='radial']");
										if (onOffData) {
											prantEmt.setAttribute("data-onoff", "ON");
											if (emtIconBg) {
												emtIconBg.classList.add("display-none");
											}
										} else if (prantEmt.getAttribute("data-onoff") !== "ON") {
											// 이미 ON으로 설정되어 있으면 OFF로 변경하지 않음 (하나라도 실행 중이면 색 유지)
											prantEmt.setAttribute("data-onoff", "OFF");
											if (emtIconBg) {
												emtIconBg.classList.remove("display-none");
											}
										}
									}
								});
							});
							
							// TODO: 삭제예정
							/*
							[...systematicDiagramContent.querySelector("#grpPump").children].forEach(emt => {
								let emtId = emt.id;
								[...emt.children].forEach(emtOnOff => {
									if (emtOnOff.id.includes("OnOff-")) {
										let onOffData = (Math.floor(Math.random() * 2)) == 0 ? false : true;
										emtOnOff.setAttribute("data-onoff", onOffData ? "ON" : "OFF");

										let emtTooltipIcon = systematicDiagramContent.querySelector("#grpPumpTooltip #" + emtOnOff.id.replace("OnOff", "TooltipIcon"));
										emtTooltipIcon.querySelectorAll("[id^='pump'] > :not([id^='pump']):last-child").forEach(emtColors => {
											let preEmt = emtColors.previousElementSibling;
											if (onOffData) {
												emtColors.classList.add("display-none");
												if (preEmt.tagName && preEmt.tagName.toLowerCase() == "circle") {
													preEmt.classList.remove("display-none");
												}
											} else {
												emtColors.classList.remove("display-none");
												if (preEmt.tagName && preEmt.tagName.toLowerCase() == "circle") {
													preEmt.classList.add("display-none");
												}
											}
										});

										let emtIconBg = emt.querySelector("#" + emtId.replace("Box", "IconBgTop") + " [fill*='radial']");
										if (onOffData || (emt.getAttribute("data-onoff") == "ON" ? true : false)) {
											emt.setAttribute("data-onoff", "ON");
											if (emtIconBg) {
												emtIconBg.classList.add("display-none");
											}
										} else {
											emt.setAttribute("data-onoff", "OFF");
											if (emtIconBg) {
												emtIconBg.classList.remove("display-none");
											}
										}
									}
								});
							});
							*/
						}
					});
				};
				timeOutData(ajaxDataFunc);

				$("#contents").html(systematicDiagramContent);
			});
		};

		$( window ).on("resize", function() {
			//checkFullScreenMode();
		});

		function checkFullScreenMode() {
			if (window.innerHeight >= window.screen.availHeight) {
				$(".leftBox").hide();
				const width = window.innerWidth;
				const height = window.innerHeight; //document.body.clientHeight;

				$("#contents").width(width);
				$("#contents").height(height);
				$(".contentBox").width(width);
				$(".contentBox").height(height);
				$(".contentBox").css("margin-top", "-3.5rem");
			} else {
				$(".leftBox").show();
				const width = window.innerWidth - 110;
				let height = window.innerHeight;// document.body.clientHeight;
				$("#contents").width(width);
				$("#contents").height(height);
				$(".contentBox").width(width);
				$(".contentBox").height(height);
				$(".contentBox").css("margin-top", "-3.5rem");
			}
			let id = document.querySelectorAll(".navi-path.active")[0].id;
			drawBackground(id);
		};

		function onClickNavi(id) {
			$(".navi-path").each(function(index, item) {
				item.classList.remove("active");
			});
			$("#" + id).addClass("active");
			switch(id) {
				case "1":
					$("#contents").width("");
					$("#contents").height("");
					loadMain();
					break;
				case "2":
					$("#contents").width("");
					$("#contents").height("");
					loadSystematicDiagram();
					break;
				case "3":
					/*
					$("#contents").load("resources/html/contents3.html?time="+(new Date()).format("yyyymmddhhmmss"), function(){
						checkFullScreenMode();
					});
					*/
					$("#contents").width("");
					$("#contents").height("");
					loadProcessChart();
					break;
				case "5":
					$("#contents").width("");
					$("#contents").height("");
					loadFloorPlan();
					break;
			}
		};

		let defInfo = {
			"3" : {
				background: "resources/images/view/db/db0103/contents3/BG03.png",
				backDftWidth: 1810,
				backDftHeight: 945,
				contents: {
					"Cflow1":{width: 176, height: 168, left: 180, top: 76},
					"Cflow2":{width: 174, height: 168, left: 394, top: 76},
					"Cflow3":{width: 176, height: 168, left: 606, top: 76},
					"Cflow4":{width: 176, height: 168, left: 820, top: 76},
					"Cflow5":{width: 173, height: 168, left: 1035, top: 76},
					"Cflow6":{width: 184, height: 166, left: 1243, top: 227},
					"Cflow7":{width: 177, height: 168, left: 1246, top: 76},
					"Cflow8":{width: 174, height: 168, left: 1461, top: 76},
					"Cflow9":{width: 176, height: 168, left: 1673, top: 76},
					"Cflow_data1":{width: 422, height: 182, left: 160, top: 252},
					"Cflow_data2":{width: 343, height: 214, left: 310, top: 252},
					"Cflow_data3":{width: 350, height: 150, left: 520, top: 252},
					"Cflow_data4":{width: 278, height: 214, left: 770, top: 252},
					"Cflow_data5":{width: 296, height: 142, left: 974, top: 252},
					"Cflow_data7":{width: 214, height: 182, left: 1228, top: 252},
					"Cflow_data8":{width: 214, height: 182, left: 1441, top: 252},
					"Cflow_data9":{width: 201, height: 118, left: 1660, top: 252},
					"content1":{width: 241, height: 152, left: 486, top: 423},
					"content2":{width: 243, height: 152, left: 755, top: 420},
					"content3":{width: 239, height: 149, left: 1032, top: 420},
					"content4":{width: 239, height: 149, left: 1305, top: 420},
					"content5":{width: 239, height: 149, left: 1575, top: 420},
					"Cdata1":{width: 936, height: 424, left: 720, top: 398},
					"Cdata2":{width: 920, height: 422, left: 990, top: 398},
					"Cdata3":{width: 764, height: 629, left: 285, top: 309},
					"Cdata4":{width: 765, height: 801, left: 559, top: 138},
					"label1": {width: 74, height: 31, left: 155, top: 584},
					"label2": {width: 74, height: 31, left: 233, top: 584},
					"image-container": {width: 1736, height: 307, left:153, top: 618},
					"popup_1": {width: 162, height: 200, left:193, top: 77},
					"content1-gif": {width: 120, height: 19, left:316, top: 177},
					"content2-gif": {width: 120, height: 19, left:535, top: 177},
					"content3-gif": {width: 120, height: 19, left:745, top: 177},
					"content4-gif": {width: 120, height: 19, left:957, top: 177},
					"content5-gif": {width: 120, height: 19, left:1170, top: 177},
					"content6-gif": {width: 120, height: 19, left:1387, top: 177},
					"content7-gif": {width: 120, height: 19, left:1593, top: 177},
					"content8-gif": {width: 120, height: 19, left:1168, top: 248},
					"content9-gif": {width: 120, height: 19, left:1384, top: 248},
					"content10-gif": {width: 120, height: 19, left:1231, top: 326},
					"content11-gif": {width: 120, height: 19, left:1317, top: 326},
				}
			}
		};

		function drawBackground(id) {
			let canvas = document.getElementById("Graphics");
			canvas.width = $(".contentBox").width();
			canvas.height = $(".contentBox").height();
			let context = canvas.getContext("2d");
			let image = new Image();
			image.src = defInfo[id].background;
			image.onload = function() {
				let rect = canvas.getBoundingClientRect();
				context.drawImage(image, 0, 0, rect.width, rect.height);
				for (let eleId in defInfo[id].contents) {
					calcZoomRatio(id, eleId, rect);
				}
			}
		};

		function calcZoomRatio(id, eleId, rect) {
			let contentH1 = document.getElementsByClassName(eleId)[0];
			if (!!contentH1) {
				let width = rect.width;
				let height = rect.height;

				let zoomRatioX = width / defInfo[id].backDftWidth;
				let zoomRatioY = height / defInfo[id].backDftHeight;

				//zoomX: zoomRatioX, zoomY: zoomRatioY, zoom: Math.min(zoomRatioX, zoomRatioY)

				contentH1.style.width = defInfo[id]["contents"][eleId].width * zoomRatioX;
				contentH1.style.height = defInfo[id]["contents"][eleId].height * zoomRatioY;
				contentH1.style.left = (defInfo[id]["contents"][eleId].left * zoomRatioX) - $(".leftBox").width();
				contentH1.style.right = (defInfo[id]["contents"][eleId].right * zoomRatioX);

				if (window.innerHeight >= window.screen.availHeight) {
					if (eleId == "data-bar") {
						//contentH1.style.left = 0;
					}
					if (eleId === "content8-gif" || eleId === "content9-gif") {
						contentH1.style.left = (defInfo[id]["contents"][eleId].left * zoomRatioX) - $(".leftBox").width() - 6;
					}
				}
				contentH1.style.top = (defInfo[id]["contents"][eleId].top * zoomRatioY);
			}
		};

		function showPop(id, option) {
			window.open("popup/db/" + id, "_blank", option);
		};
	</script>
</body>
</html>