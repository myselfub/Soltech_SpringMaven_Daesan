<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>RO(SW,BW) 실시 설계서</title>
<script type="text/javascript">
	window.onload = function() {
		if (dataObj) {
			dataObj.isEvent = false;
			dataObj.eventTime = 10;
			dataObj.timeOutTime = 10;
			dataObj.timeOutId = null;
		} else {
			window.dataObj = {
				isEvent: false,
				eventTime: 10,
				timeOutTime: 10,
				timeOutId: null
			};
		}
		if (dataObj.url) {
			let urlLast = dataObj.url.split("/").slice(-1)[0];
			let sizeArr = dataObj.popupSize[urlLast] || dataObj.popupSize["rest"];
			self.resizeTo(sizeArr[0], sizeArr[1]);
		}
		loadData();
	};

	function ajaxImg(imgNm) {
		return new Promise((resolve, reject) => {
			$.ajax ({
				type: "GET",
				contentType: "xml; charset=UTF-8",
				url: "/resources/images/view/db/popup/" + imgNm,
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
				let splited = item.split(",");
				splited.forEach(splitedItem => {
					newTagList.push(splitedItem.trim());
				});
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
						} else {
							resultItem = resultParam.find(paramItem => paramItem.name == tagName);
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

	function loadData() {
		dataObj.tagMapping = {
			"data-01-01" : "CDSWSS.PIT418S.F_CV",
			"data-01-02" : "CDSWSS.PIT428S.F_CV",
			"data-01-03" : "CDSWSS.PIT438S.F_CV",
			"data-01-04" : "CDSWSS.PIT448S.F_CV",
			"data-01-05" : "CDSWSS.PIT458S.F_CV",
			"data-01-06" : "CDSWSS.PIT468S.F_CV",
			"data-01-07" : "CDSWSS.PIT411S.F_CV",
			"data-01-08" : "CDSWSS.PIT421S.F_CV",
			"data-01-09" : "CDSWSS.PIT431S.F_CV",
			"data-01-10" : "CDSWSS.PIT441S.F_CV",
			"data-01-11" : "CDSWSS.PIT451S.F_CV",
			"data-01-12" : "CDSWSS.PIT461S.F_CV",
			"data-01-13" : "CDSWSS.M422A_FO_STS.F_CV",
			"data-01-14" : "CDSWSS.M422B_FO_STS.F_CV",
			"data-01-15" : "CDSWSS.M422C_FO_STS.F_CV",
			"data-01-16" : "CDSWSS.M422D_FO_STS.F_CV",
			"data-01-17" : "CDSWSS.M422E_FO_STS.F_CV",
			"data-01-18" : "CDSWSS.M422F_FO_STS.F_CV",
			"data-01-19" : "CDSWSS.M403A_RUN_STS.F_CV",
			"data-01-20" : "CDSWSS.M403B_RUN_STS.F_CV",
			"data-01-21" : "CDSWSS.M403C_RUN_STS.F_CV",
			"data-01-22" : "CDSWSS.M403D_RUN_STS.F_CV",
			"data-01-23" : "CDSWSS.M403E_RUN_STS.F_CV",
			"data-01-24" : "CDSWSS.M403F_RUN_STS.F_CV",
			"data-01-25" : "CDSWSS.M404A_RUN_STS.F_CV",
			"data-01-26" : "CDSWSS.M404B_RUN_STS.F_CV",
			"data-01-27" : "CDSWSS.M404C_RUN_STS.F_CV",
			"data-01-28" : "CDSWSS.M404D_RUN_STS.F_CV",
			"data-01-29" : "CDSWSS.M404E_RUN_STS.F_CV",
			"data-01-30" : "CDSWSS.M404F_RUN_STS.F_CV",
			"data-01-31" : "CDSWSS.M428A_FO_STS.F_CV",
			"data-01-32" : "CDSWSS.M428B_FO_STS.F_CV",
			"data-01-33" : "CDSWSS.M428C_FO_STS.F_CV",
			"data-01-34" : "CDSWSS.M428D_FO_STS.F_CV",
			"data-01-35" : "CDSWSS.M428E_FO_STS.F_CV",
			"data-01-36" : "CDSWSS.M428F_FO_STS.F_CV",
			"data-01-37" : "CDSWSS.M429A_FO_STS.F_CV",
			"data-01-38" : "CDSWSS.M429B_FO_STS.F_CV",
			"data-01-39" : "CDSWSS.M429C_FO_STS.F_CV",
			"data-01-40" : "CDSWSS.M429D_FO_STS.F_CV",
			"data-01-41" : "CDSWSS.M429E_FO_STS.F_CV",
			"data-01-42" : "CDSWSS.M429F_FO_STS.F_CV",
			"data-01-43" : "CDSWSS.FIT411S.F_CV",
			"data-01-44" : "CDSWSS.FIT421S.F_CV",
			"data-01-45" : "CDSWSS.FIT431S.F_CV",
			"data-01-46" : "CDSWSS.FIT441S.F_CV",
			"data-01-47" : "CDSWSS.FIT451S.F_CV",
			"data-01-48" : "CDSWSS.FIT461S.F_CV",
			"data-01-49" : "CDSWSS.FIT412S.F_CV",
			"data-01-50" : "CDSWSS.FIT422S.F_CV",
			"data-01-51" : "CDSWSS.FIT432S.F_CV",
			"data-01-52" : "CDSWSS.FIT442S.F_CV",
			"data-01-53" : "CDSWSS.FIT452S.F_CV",
			"data-01-54" : "CDSWSS.FIT462S.F_CV",
			"data-01-55" : "CDSWSS.CE411S.F_CV",
			"data-01-56" : "CDSWSS.CE421S.F_CV",
			"data-01-57" : "CDSWSS.CE431S.F_CV",
			"data-01-58" : "CDSWSS.CE441S.F_CV",
			"data-01-59" : "CDSWSS.CE451S.F_CV",
			"data-01-60" : "CDSWSS.CE461S.F_CV",
			"data-01-61" : "CDSWSS.CE414S.F_CV",
			"data-01-62" : "CDSWSS.CE424S.F_CV",
			"data-01-63" : "CDSWSS.CE434S.F_CV",
			"data-01-64" : "CDSWSS.CE444S.F_CV",
			"data-01-65" : "CDSWSS.CE454S.F_CV",
			"data-01-66" : "CDSWSS.CE464S.F_CV",
			"data-01-67" : "CDSWSS.CE412S.F_CV",
			"data-01-68" : "CDSWSS.CE422S.F_CV",
			"data-01-69" : "CDSWSS.CE432S.F_CV",
			"data-01-70" : "CDSWSS.CE442S.F_CV",
			"data-01-71" : "CDSWSS.CE452S.F_CV",
			"data-01-72" : "CDSWSS.CE462S.F_CV",
			"data-01-73" : "CDSWSS.CE413S.F_CV",
			"data-01-74" : "CDSWSS.CE423S.F_CV",
			"data-01-75" : "CDSWSS.CE433S.F_CV",
			"data-01-76" : "CDSWSS.CE443S.F_CV",
			"data-01-77" : "CDSWSS.CE453S.F_CV",
			"data-01-78" : "CDSWSS.CE463S.F_CV",
			"data-02-01" : "CDSWSS.PIT411B.F_CV",
			"data-02-02" : "CDSWSS.PIT421B.F_CV",
			"data-02-03" : "CDSWSS.PIT431B.F_CV",
			"data-02-04" : "CDSWSS.PIT441B.F_CV",
			"data-02-05" : "CDSWSS.PIT451B.F_CV",
			"data-02-06" : "CDSWSS.PIT461B.F_CV",
			"data-02-07" : "CDSWSS.PIT414B.F_CV",
			"data-02-08" : "CDSWSS.PIT424B.F_CV",
			"data-02-09" : "CDSWSS.PIT434B.F_CV",
			"data-02-10" : "CDSWSS.PIT444B.F_CV",
			"data-02-11" : "CDSWSS.PIT454B.F_CV",
			"data-02-12" : "CDSWSS.PIT464B.F_CV",
			"data-02-13" : "CDSWSS.PIT413B.F_CV",
			"data-02-14" : "CDSWSS.PIT423B.F_CV",
			"data-02-15" : "CDSWSS.PIT433B.F_CV",
			"data-02-16" : "CDSWSS.PIT443B.F_CV",
			"data-02-17" : "CDSWSS.PIT453B.F_CV",
			"data-02-18" : "CDSWSS.PIT463B.F_CV",
			"data-02-19" : "CDSWSS.M407A_RUN_STS.F_CV",
			"data-02-20" : "CDSWSS.M407B_RUN_STS.F_CV",
			"data-02-21" : "CDSWSS.M407C_RUN_STS.F_CV",
			"data-02-22" : "CDSWSS.M407D_RUN_STS.F_CV",
			"data-02-23" : "CDSWSS.M407E_RUN_STS.F_CV",
			"data-02-24" : "CDSWSS.M407F_RUN_STS.F_CV",
			"data-02-25" : "CDSWSS.M433A_FO_STS.F_CV",
			"data-02-26" : "CDSWSS.M433B_FO_STS.F_CV",
			"data-02-27" : "CDSWSS.M433C_FO_STS.F_CV",
			"data-02-28" : "CDSWSS.M433D_FO_STS.F_CV",
			"data-02-29" : "CDSWSS.M433E_FO_STS.F_CV",
			"data-02-30" : "CDSWSS.M433F_FO_STS.F_CV",
			"data-02-31" : "CDSWSS.M444A_FO_STS.F_CV",
			"data-02-32" : "CDSWSS.M444B_FO_STS.F_CV",
			"data-02-33" : "CDSWSS.M444C_FO_STS.F_CV",
			"data-02-34" : "CDSWSS.M444D_FO_STS.F_CV",
			"data-02-35" : "CDSWSS.M444E_FO_STS.F_CV",
			"data-02-36" : "CDSWSS.M444F_FO_STS.F_CV",
			"data-02-37" : "CDSWSS.M452A_FO_STS.F_CV",
			"data-02-38" : "CDSWSS.M452B_FO_STS.F_CV",
			"data-02-39" : "CDSWSS.M452C_FO_STS.F_CV",
			"data-02-40" : "CDSWSS.M452D_FO_STS.F_CV",
			"data-02-41" : "CDSWSS.M452E_FO_STS.F_CV",
			"data-02-42" : "CDSWSS.M452F_FO_STS.F_CV",
			"data-02-43" : "CDSWSS.M434A_FO_STS.F_CV",
			"data-02-44" : "CDSWSS.M434B_FO_STS.F_CV",
			"data-02-45" : "CDSWSS.M434C_FO_STS.F_CV",
			"data-02-46" : "CDSWSS.M434D_FO_STS.F_CV",
			"data-02-47" : "CDSWSS.M434E_FO_STS.F_CV",
			"data-02-48" : "CDSWSS.M434F_FO_STS.F_CV",
			"data-02-49" : "CDSWSS.FIT411B.F_CV",
			"data-02-50" : "CDSWSS.FIT421B.F_CV",
			"data-02-51" : "CDSWSS.FIT431B.F_CV",
			"data-02-52" : "CDSWSS.FIT441B.F_CV",
			"data-02-53" : "CDSWSS.FIT451B.F_CV",
			"data-02-54" : "CDSWSS.FIT461B.F_CV",
			"data-02-55" : "CDSWSS.FIT412B.F_CV",
			"data-02-56" : "CDSWSS.FIT422B.F_CV",
			"data-02-57" : "CDSWSS.FIT432B.F_CV",
			"data-02-58" : "CDSWSS.FIT442B.F_CV",
			"data-02-59" : "CDSWSS.FIT452B.F_CV",
			"data-02-60" : "CDSWSS.FIT462B.F_CV",
			"data-02-61" : "CDSWSS.FIT413B.F_CV",
			"data-02-62" : "CDSWSS.FIT423B.F_CV",
			"data-02-63" : "CDSWSS.FIT433B.F_CV",
			"data-02-64" : "CDSWSS.FIT443B.F_CV",
			"data-02-65" : "CDSWSS.FIT453B.F_CV",
			"data-02-66" : "CDSWSS.FIT463B.F_CV",
			"data-02-67" : "CDSWSS.PH411B.F_CV",
			"data-02-68" : "CDSWSS.PH421B.F_CV",
			"data-02-69" : "CDSWSS.PH431B.F_CV",
			"data-02-70" : "CDSWSS.PH441B.F_CV",
			"data-02-71" : "CDSWSS.PH451B.F_CV",
			"data-02-72" : "CDSWSS.PH461B.F_CV",
			"data-02-73" : "CDSWSS.CE411B.F_CV",
			"data-02-74" : "CDSWSS.CE421B.F_CV",
			"data-02-75" : "CDSWSS.CE431B.F_CV",
			"data-02-76" : "CDSWSS.CE441B.F_CV",
			"data-02-77" : "CDSWSS.CE451B.F_CV",
			"data-02-78" : "CDSWSS.CE461B.F_CV",
			"data-02-79" : "CDSWSS.CE412B.F_CV",
			"data-02-80" : "CDSWSS.CE422B.F_CV",
			"data-02-81" : "CDSWSS.CE432B.F_CV",
			"data-02-82" : "CDSWSS.CE442B.F_CV",
			"data-02-83" : "CDSWSS.CE452B.F_CV",
			"data-02-84" : "CDSWSS.CE462B.F_CV",
		};

		setDataAtt(dataObj.tagMapping, document);

		// SVG
		ajaxImg("RO.svg").then((emtSvg) => {
			$("#imgContents").append(emtSvg);

			let ajaxDataFunc = () => {
				ajaxData(Object.values(dataObj.tagMapping)).then((res) => {
					if (res) {
						res.param.forEach(item => {
							let emts = document.querySelectorAll("[data-tag='" + item.name + "']");
							emts.forEach(emt => {
								if (emt.tagName && emt.tagName.toLowerCase() == "span") {
									let preText = emt.textContent;
									let itemVal = item.val;
									if (itemVal != null) {
										if (preText != itemVal.toLocaleString("ko-KR")) {
											emt.textContent = itemVal.toLocaleString("ko-KR");
										}
									} else {
										emt.textContent = itemVal;
									}
								} else if (emt.tagName && emt.tagName.toLowerCase() == "img") {
									let onOffData = Number(item.val) == 0 ? false : true;
									if (onOffData) {
										emt.classList.add("on-img");
										emt.classList.remove("off-img");
									} else {
										emt.classList.remove("on-img");
										emt.classList.add("off-img");
									}
								}
							});
						});
					}
				});
			};
			timeOutData(ajaxDataFunc);
		});
	};
</script>
</head>
<body>
	<div class="scrollBox">
		<div class="area">
			<p class="area-title">데이터</p>
			<div class="real-data-box">
				<div class="data-box">
					<div class="title">SWRO 주요 현황</div>
					<div class="values">
						<div class="value">
							<p class="tit" style="flex: 1;"></p>
							<div class="value-arr" style="flex: 2.5;">
								<span class="val">#1</span> <span class="val">#2</span> <span
									class="val">#3</span> <span class="val">#4</span> <span
									class="val">#5</span> <span class="val">#6</span>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">SWRO 유입압력 (㎏/㎠)</p>
							<div class="value-arr" style="flex: 2.5;">
								<span id="data-01-01" class="val">-</span> <span id="data-01-02"
									class="val">-</span> <span id="data-01-03" class="val">-</span>
								<span id="data-01-04" class="val">-</span> <span id="data-01-05"
									class="val">-</span> <span id="data-01-06" class="val">-</span>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">SWRO 유출압력 (㎏/㎠)</p>
							<div class="value-arr" style="flex: 2.5;">
								<span id="data-01-07" class="val">-</span> <span id="data-01-08"
									class="val">-</span> <span id="data-01-09" class="val">-</span>
								<span id="data-01-10" class="val">-</span> <span id="data-01-11"
									class="val">-</span> <span id="data-01-12" class="val">-</span>
							</div>
						</div>
						<div class="value img-item">
							<p class="tit" style="flex: 1;">SWRO 유입밸브</p>
							<div class="value-arr" style="flex: 2.5;">
								<span class="val"><img id="data-01-13" class="off-img"></span>
								<span class="val"><img id="data-01-14" class="off-img"></span>
								<span class="val"><img id="data-01-15" class="off-img"></span>
								<span class="val"><img id="data-01-16" class="off-img"></span>
								<span class="val"><img id="data-01-17" class="off-img"></span>
								<span class="val"><img id="data-01-18" class="off-img"></span>
							</div>
						</div>
						<div class="value img-item">
							<p class="tit" style="flex: 1;">고압펌프</p>
							<div class="value-arr" style="flex: 2.5;">
								<span class="val"><img id="data-01-19" class="off-img"></span>
								<span class="val"><img id="data-01-20" class="off-img"></span>
								<span class="val"><img id="data-01-21" class="off-img"></span>
								<span class="val"><img id="data-01-22" class="off-img"></span>
								<span class="val"><img id="data-01-23" class="off-img"></span>
								<span class="val"><img id="data-01-24" class="off-img"></span>
							</div>
						</div>
						<div class="value img-item">
							<p class="tit" style="flex: 1;">부스터펌프</p>
							<div class="value-arr" style="flex: 2.5;">
								<span class="val"><img id="data-01-25" class="off-img"></span>
								<span class="val"><img id="data-01-26" class="off-img"></span>
								<span class="val"><img id="data-01-27" class="off-img"></span>
								<span class="val"><img id="data-01-28" class="off-img"></span>
								<span class="val"><img id="data-01-29" class="off-img"></span>
								<span class="val"><img id="data-01-30" class="off-img"></span>
							</div>
						</div>
						<div class="value img-item">
							<p class="tit" style="flex: 1;">CIP 유출밸브</p>
							<div class="value-arr" style="flex: 2.5;">
								<span class="val"><img id="data-01-31" class="off-img"></span>
								<span class="val"><img id="data-01-32" class="off-img"></span>
								<span class="val"><img id="data-01-33" class="off-img"></span>
								<span class="val"><img id="data-01-34" class="off-img"></span>
								<span class="val"><img id="data-01-35" class="off-img"></span>
								<span class="val"><img id="data-01-36" class="off-img"></span>
							</div>
						</div>
						<div class="value img-item">
							<p class="tit" style="flex: 1;">CIP 배출밸브</p>
							<div class="value-arr" style="flex: 2.5;">
								<span class="val"><img id="data-01-37" class="off-img"></span>
								<span class="val"><img id="data-01-38" class="off-img"></span>
								<span class="val"><img id="data-01-39" class="off-img"></span>
								<span class="val"><img id="data-01-40" class="off-img"></span>
								<span class="val"><img id="data-01-41" class="off-img"></span>
								<span class="val"><img id="data-01-42" class="off-img"></span>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">SWRO 유입유량 (㎥)</p>
							<div class="value-arr" style="flex: 2.5;">
								<span id="data-01-43" class="val">-</span> <span id="data-01-44"
									class="val">-</span> <span id="data-01-45" class="val">-</span>
								<span id="data-01-46" class="val">-</span> <span id="data-01-47"
									class="val">-</span> <span id="data-01-48" class="val">-</span>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">SWRO 유출유량 (㎥)</p>
							<div class="value-arr" style="flex: 2.5;">
								<span id="data-01-49" class="val">-</span> <span id="data-01-50"
									class="val">-</span> <span id="data-01-51" class="val">-</span>
								<span id="data-01-52" class="val">-</span> <span id="data-01-53"
									class="val">-</span> <span id="data-01-54" class="val">-</span>
							</div>
						</div>
						<div class="value-ttl" style="border-top: 2px dotted #333333;">SWRO
							수질 데이터</div>
						<div class="value">
							<p class="tit" style="flex: 1;">유입 전기전도도 (Ph)</p>
							<div class="value-arr" style="flex: 2.5;">
								<span id="data-01-55" class="val">-</span> <span id="data-01-56"
									class="val">-</span> <span id="data-01-57" class="val">-</span>
								<span id="data-01-58" class="val">-</span> <span id="data-01-59"
									class="val">-</span> <span id="data-01-60" class="val">-</span>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">유출 전기전도도 (㎎/L)</p>
							<div class="value-arr" style="flex: 2.5;">
								<span id="data-01-61" class="val">-</span> <span id="data-01-62"
									class="val">-</span> <span id="data-01-63" class="val">-</span>
								<span id="data-01-64" class="val">-</span> <span id="data-01-65"
									class="val">-</span> <span id="data-01-66" class="val">-</span>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">농축수 유출 전기전도도 (㎲/㎝)</p>
							<div class="value-arr" style="flex: 2.5;">
								<span id="data-01-67" class="val">-</span> <span id="data-01-68"
									class="val">-</span> <span id="data-01-69" class="val">-</span>
								<span id="data-01-70" class="val">-</span> <span id="data-01-71"
									class="val">-</span> <span id="data-01-72" class="val">-</span>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">부스터펌프 유입 전기전도도 (㎎/L)</p>
							<div class="value-arr" style="flex: 2.5;">
								<span id="data-01-73" class="val">-</span> <span id="data-01-74"
									class="val">-</span> <span id="data-01-75" class="val">-</span>
								<span id="data-01-76" class="val">-</span> <span id="data-01-77"
									class="val">-</span> <span id="data-01-78" class="val">-</span>
							</div>
						</div>
					</div>
				</div>
				<div class="data-box">
					<div class="title">BWRO 주요 현황</div>
					<div class="values">
						<div class="value">
							<p class="tit" style="flex: 1;"></p>
							<div class="value-arr" style="flex: 2.5;">
								<span class="val">#1</span> <span class="val">#2</span> <span
									class="val">#3</span> <span class="val">#4</span> <span
									class="val">#5</span> <span class="val">#6</span>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">BWRO 유입 압력</p>
							<div class="value-arr" style="flex: 2.5;">
								<span id="data-02-01" class="val">-</span> <span id="data-02-02"
									class="val">-</span> <span id="data-02-03" class="val">-</span>
								<span id="data-02-04" class="val">-</span> <span id="data-02-05"
									class="val">-</span> <span id="data-02-06" class="val">-</span>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">BWRO 1단 유출압력 (㎏/㎠)</p>
							<div class="value-arr" style="flex: 2.5;">
								<span id="data-02-07" class="val">-</span> <span id="data-02-08"
									class="val">-</span> <span id="data-02-09" class="val">-</span>
								<span id="data-02-10" class="val">-</span> <span id="data-02-11"
									class="val">-</span> <span id="data-02-12" class="val">-</span>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">BWRO 2단 유출압력 (㎏/㎠)</p>
							<div class="value-arr" style="flex: 2.5;">
								<span id="data-02-13" class="val">-</span> <span id="data-02-14"
									class="val">-</span> <span id="data-02-15" class="val">-</span>
								<span id="data-02-16" class="val">-</span> <span id="data-02-17"
									class="val">-</span> <span id="data-02-18" class="val">-</span>
							</div>
						</div>
						<div class="value img-item">
							<p class="tit" style="flex: 1;">고압펌프</p>
							<div class="value-arr" style="flex: 2.5;">
								<span class="val"><img id="data-02-19" class="off-img"></span>
								<span class="val"><img id="data-02-20" class="off-img"></span>
								<span class="val"><img id="data-02-21" class="off-img"></span>
								<span class="val"><img id="data-02-22" class="off-img"></span>
								<span class="val"><img id="data-02-23" class="off-img"></span>
								<span class="val"><img id="data-02-24" class="off-img"></span>
							</div>
						</div>
						<div class="value img-item">
							<p class="tit" style="flex: 1;">유출밸브</p>
							<div class="value-arr" style="flex: 2.5;">
								<span class="val"><img id="data-02-25" class="off-img"></span>
								<span class="val"><img id="data-02-26" class="off-img"></span>
								<span class="val"><img id="data-02-27" class="off-img"></span>
								<span class="val"><img id="data-02-28" class="off-img"></span>
								<span class="val"><img id="data-02-29" class="off-img"></span>
								<span class="val"><img id="data-02-30" class="off-img"></span>
							</div>
						</div>
						<div class="value img-item">
							<p class="tit" style="flex: 1;">유량조절밸브</p>
							<div class="value-arr" style="flex: 2.5;">
								<span class="val"><img id="data-02-31" class="off-img"></span>
								<span class="val"><img id="data-02-32" class="off-img"></span>
								<span class="val"><img id="data-02-33" class="off-img"></span>
								<span class="val"><img id="data-02-34" class="off-img"></span>
								<span class="val"><img id="data-02-35" class="off-img"></span>
								<span class="val"><img id="data-02-36" class="off-img"></span>
							</div>
						</div>
						<div class="value img-item">
							<p class="tit" style="flex: 1;">유입차단밸브</p>
							<div class="value-arr" style="flex: 2.5;">
								<span class="val"><img id="data-02-37" class="off-img"></span>
								<span class="val"><img id="data-02-38" class="off-img"></span>
								<span class="val"><img id="data-02-39" class="off-img"></span>
								<span class="val"><img id="data-02-40" class="off-img"></span>
								<span class="val"><img id="data-02-41" class="off-img"></span>
								<span class="val"><img id="data-02-42" class="off-img"></span>
							</div>
						</div>
						<div class="value img-item">
							<p class="tit" style="flex: 1;">농축수유출밸브</p>
							<div class="value-arr" style="flex: 2.5;">
								<span class="val"><img id="data-02-43" class="off-img"></span>
								<span class="val"><img id="data-02-44" class="off-img"></span>
								<span class="val"><img id="data-02-45" class="off-img"></span>
								<span class="val"><img id="data-02-46" class="off-img"></span>
								<span class="val"><img id="data-02-47" class="off-img"></span>
								<span class="val"><img id="data-02-48" class="off-img"></span>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">BWRO 유입유량 (㎥)</p>
							<div class="value-arr" style="flex: 2.5;">
								<span id="data-02-49" class="val">-</span> <span id="data-02-50"
									class="val">-</span> <span id="data-02-51" class="val">-</span>
								<span id="data-02-52" class="val">-</span> <span id="data-02-53"
									class="val">-</span> <span id="data-02-54" class="val">-</span>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">BWRO 1단 유출유량 (㎥)</p>
							<div class="value-arr" style="flex: 2.5;">
								<span id="data-02-55" class="val">-</span> <span id="data-02-56"
									class="val">-</span> <span id="data-02-57" class="val">-</span>
								<span id="data-02-58" class="val">-</span> <span id="data-02-59"
									class="val">-</span> <span id="data-02-60" class="val">-</span>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">BWRO 2단 유출유량 (㎥)</p>
							<div class="value-arr" style="flex: 2.5;">
								<span id="data-02-61" class="val">-</span> <span id="data-02-62"
									class="val">-</span> <span id="data-02-63" class="val">-</span>
								<span id="data-02-64" class="val">-</span> <span id="data-02-65"
									class="val">-</span> <span id="data-02-66" class="val">-</span>
							</div>
						</div>
						<div class="value-ttl" style="border-top: 2px dotted #333333;">BWRO
							수질 데이터</div>
						<div class="value">
							<p class="tit" style="flex: 1;">유출 수소이온농도 (NTU)</p>
							<div class="value-arr" style="flex: 2.5;">
								<span id="data-02-67" class="val">-</span> <span id="data-02-68"
									class="val">-</span> <span id="data-02-69" class="val">-</span>
								<span id="data-02-70" class="val">-</span> <span id="data-02-71"
									class="val">-</span> <span id="data-02-72" class="val">-</span>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">유출 전기전도도 (Ph)</p>
							<div class="value-arr" style="flex: 2.5;">
								<span id="data-02-73" class="val">-</span> <span id="data-02-74"
									class="val">-</span> <span id="data-02-75" class="val">-</span>
								<span id="data-02-76" class="val">-</span> <span id="data-02-77"
									class="val">-</span> <span id="data-02-78" class="val">-</span>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">농축수 유출 전기전도도 (Ph)</p>
							<div class="value-arr" style="flex: 2.5;">
								<span id="data-02-79" class="val">-</span> <span id="data-02-80"
									class="val">-</span> <span id="data-02-81" class="val">-</span>
								<span id="data-02-82" class="val">-</span> <span id="data-02-83"
									class="val">-</span> <span id="data-02-84" class="val">-</span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div id="imgContents" class="area">
				<p class="area-title">공정 상세</p>
			</div>
		</div>
	</div>
</body>
</html>