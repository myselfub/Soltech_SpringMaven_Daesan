<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전처리(DMGF) 실시 설계서</title>
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
			"data-01-01" : "CDSWSS.TOC301.F_CV",
			"data-01-02" : "CDSWSS.CE301.F_CV",
			"data-01-03" : "CDSWSS.Ph301.F_CV",
			"data-01-04" : "CDSWSS.TbE301.F_CV",
			"data-01-05" : "CDSWSS.Cl2301.F_CV",
			"data-02-01" : "CDSWSS.DMGF_A_FILT_ST_SEQ_RUN.F_CV",
			"data-02-02" : "CDSWSS.DMGF_B_FILT_ST_SEQ_RUN.F_CV",
			"data-02-03" : "CDSWSS.DMGF_C_FILT_ST_SEQ_RUN.F_CV",
			"data-02-04" : "CDSWSS.DMGF_D_FILT_ST_SEQ_RUN.F_CV",
			"data-02-05" : "CDSWSS.DMGF_E_FILT_ST_SEQ_RUN.F_CV",
			"data-02-06" : "CDSWSS.DMGF_F_FILT_ST_SEQ_RUN.F_CV",
			"data-02-07" : "CDSWSS.DMGF_G_FILT_ST_SEQ_RUN.F_CV",
			"data-02-08" : "CDSWSS.DMGF_H_FILT_ST_SEQ_RUN.F_CV",
			"data-02-09" : "CDSWSS.DMGF_I_FILT_ST_SEQ_RUN.F_CV",
			"data-02-10" : "CDSWSS.DMGF_J_FILT_ST_SEQ_RUN.F_CV",
			"data-02-11" : "CDSWSS.DMGF_K_FILT_ST_SEQ_RUN.F_CV",
			"data-02-12" : "CDSWSS.DMGF_L_FILT_ST_SEQ_RUN.F_CV",
			"data-02-13" : "CDSWSS.DMGF_M_FILT_ST_SEQ_RUN.F_CV",
			"data-02-14" : "CDSWSS.DMGF_N_FILT_ST_SEQ_RUN.F_CV",
			"data-02-15" : "CDSWSS.LIT311A.F_CV",
			"data-02-16" : "CDSWSS.LIT311B.F_CV",
			"data-02-17" : "CDSWSS.LIT311C.F_CV",
			"data-02-18" : "CDSWSS.LIT311D.F_CV",
			"data-02-19" : "CDSWSS.LIT311E.F_CV",
			"data-02-20" : "CDSWSS.LIT311F.F_CV",
			"data-02-21" : "CDSWSS.LIT311G.F_CV",
			"data-02-22" : "CDSWSS.LIT311H.F_CV",
			"data-02-23" : "CDSWSS.LIT311I.F_CV",
			"data-02-24" : "CDSWSS.LIT311J.F_CV",
			"data-02-25" : "CDSWSS.LIT311K.F_CV",
			"data-02-26" : "CDSWSS.LIT311L.F_CV",
			"data-02-27" : "CDSWSS.LIT311M.F_CV",
			"data-02-28" : "CDSWSS.LIT311N.F_CV",
			"data-02-29" : "CDSWSS.TbE311A.F_CV",
			"data-02-30" : "CDSWSS.TbE311B.F_CV",
			"data-02-31" : "CDSWSS.TbE311C.F_CV",
			"data-02-32" : "CDSWSS.TbE311D.F_CV",
			"data-02-33" : "CDSWSS.TbE311E.F_CV",
			"data-02-34" : "CDSWSS.TbE311F.F_CV",
			"data-02-35" : "CDSWSS.TbE311G.F_CV",
			"data-02-36" : "CDSWSS.TbE311H.F_CV",
			"data-02-37" : "CDSWSS.TbE311I.F_CV",
			"data-02-38" : "CDSWSS.TbE311J.F_CV",
			"data-02-39" : "CDSWSS.TbE311K.F_CV",
			"data-02-40" : "CDSWSS.TbE311L.F_CV",
			"data-02-41" : "CDSWSS.TbE311M.F_CV",
			"data-02-42" : "CDSWSS.TbE311N.F_CV",
			"data-02-43" : "CDSWSS.M304A_RUN_STS.F_CV",
			"data-02-44" : "CDSWSS.M304B_RUN_STS.F_CV",
			"data-02-45" : "CDSWSS.M304C_RUN_STS.F_CV",
			"data-02-46" : "CDSWSS.M304D_RUN_STS.F_CV",
			"data-02-47" : "CDSWSS.M304E_RUN_STS.F_CV",
			"data-02-48" : "CDSWSS.M304F_RUN_STS.F_CV",
			"data-02-49" : "CDSWSS.M304G_RUN_STS.F_CV",
			"data-02-50" : "CDSWSS.LIT321A.F_CV",
			"data-02-51" : "CDSWSS.LIT321B.F_CV",
			"data-03-01" : "CDSWSS.ORP401.F_CV",
			"data-03-02" : "CDSWSS.TBE401.F_CV",
		};

		setDataAtt(dataObj.tagMapping, document);

		// SVG
		ajaxImg("DMGF.svg").then((emtSvg) => {
			$("#imgContents").append(emtSvg);

			let ajaxDataFunc = () => {
				ajaxData(Object.values(dataObj.tagMapping)).then((res) => {
					if (res) {
						console.log(res);
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
					<div class="title">유입 수질</div>
					<div class="values">
						<div class="value">
							<p class="tit">총 유기탄소량</p>
							<div class="value-datas">
								<span id="data-01-01" class="val">-</span>
								<p class="unit">㎎/L</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">전기전도도</p>
							<div class="value-datas">
								<span id="data-01-02" class="val">-</span>
								<p class="unit">㎲/㎝</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">수소이온농도</p>
							<div class="value-datas">
								<span id="data-01-03" class="val">-</span>
								<p class="unit">Ph</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">탁도</p>
							<div class="value-datas">
								<span id="data-01-04" class="val">-</span>
								<p class="unit">NTU</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">잔류염소</p>
							<div class="value-datas">
								<span id="data-01-05" class="val">-</span>
								<p class="unit">㎎/L</p>
							</div>
						</div>
					</div>
				</div>
				<div class="data-box">
					<div class="title">DMGF</div>
					<div class="values">
						<div class="value img-item">
							<p class="tit" style="text-wrap: wrap; flex: 1;">여과제어</p>
							<div
								style="display: flex; flex-direction: column; row-gap: 5px; flex: 4;">
								<div class="value-datas">
									<span class="val"><img id="data-02-01" class="off-img"></span>
									<span class="val"><img id="data-02-02" class="off-img"></span>
									<span class="val"><img id="data-02-03" class="off-img"></span>
									<span class="val"><img id="data-02-04" class="off-img"></span>
									<span class="val"><img id="data-02-05" class="off-img"></span>
									<span class="val"><img id="data-02-06" class="off-img"></span>
									<span class="val"><img id="data-02-07" class="off-img"></span>
								</div>
								<div class="value-datas">
									<span class="val"><img id="data-02-08" class="off-img"></span>
									<span class="val"><img id="data-02-09" class="off-img"></span>
									<span class="val"><img id="data-02-10" class="off-img"></span>
									<span class="val"><img id="data-02-11" class="off-img"></span>
									<span class="val"><img id="data-02-12" class="off-img"></span>
									<span class="val"><img id="data-02-13" class="off-img"></span>
									<span class="val"><img id="data-02-14" class="off-img"></span>
								</div>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="text-wrap: wrap; flex: 1;">여과지 수위 (m)</p>
							<div
								style="display: flex; flex-direction: column; row-gap: 5px; flex: 4;">
								<div class="value-datas" style="width: 100%;">
									<span id="data-02-15" class="val">-</span>
									<span id="data-02-16" class="val">-</span>
									<span id="data-02-17" class="val">-</span>
									<span id="data-02-18" class="val">-</span>
									<span id="data-02-19" class="val">-</span>
									<span id="data-02-20" class="val">-</span>
									<span id="data-02-21" class="val">-</span>
								</div>
								<div class="value-datas" style="width: 100%;">
									<span id="data-02-22" class="val">-</span>
									<span id="data-02-23" class="val">-</span>
									<span id="data-02-24" class="val">-</span>
									<span id="data-02-25" class="val">-</span>
									<span id="data-02-26" class="val">-</span>
									<span id="data-02-27" class="val">-</span>
									<span id="data-02-28" class="val">-</span>
								</div>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="text-wrap: wrap; flex: 1;">여과지 유출수 탁도
								(NTU)</p>
							<div
								style="display: flex; flex-direction: column; row-gap: 5px; flex: 4;">
								<div class="value-datas" style="width: 100%;">
									<span id="data-02-29" class="val">-</span>
									<span id="data-02-30" class="val">-</span>
									<span id="data-02-31" class="val">-</span>
									<span id="data-02-32" class="val">-</span>
									<span id="data-02-33" class="val">-</span>
									<span id="data-02-34" class="val">-</span>
									<span id="data-02-35" class="val">-</span>
								</div>
								<div class="value-datas" style="width: 100%;">
									<span id="data-02-36" class="val">-</span>
									<span id="data-02-37" class="val">-</span>
									<span id="data-02-38" class="val">-</span>
									<span id="data-02-39" class="val">-</span>
									<span id="data-02-40" class="val">-</span>
									<span id="data-02-41" class="val">-</span>
									<span id="data-02-42" class="val">-</span>
								</div>
							</div>
						</div>
						<div class="value img-item">
							<p class="tit" style="text-wrap: wrap; flex: 1;">여과수 이송펌프</p>
							<div
								style="display: flex; flex-direction: column; row-gap: 5px; flex: 4;">
								<div class="value-datas">
									<span class="val"><img id="data-02-43" class="off-img"></span>
									<span class="val"><img id="data-02-44" class="off-img"></span>
									<span class="val"><img id="data-02-45" class="off-img"></span>
									<span class="val"><img id="data-02-46" class="off-img"></span>
									<span class="val"><img id="data-02-47" class="off-img"></span>
									<span class="val"><img id="data-02-48" class="off-img"></span>
									<span class="val"><img id="data-02-49" class="off-img"></span>
								</div>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="text-wrap: wrap; flex: 1;">여과수 저류조 수위</p>
							<div class="value-datas" style="flex: 4;">
								<span id="data-02-50" class="val" style="flex: 1;">-</span>
								<span id="data-02-51" class="val" style="flex: 1;">-</span>
								<span class="val" style="flex: 3;"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="data-box">
					<div class="title">RO 보호필터</div>
					<div class="values2" style="justify-content: flex-start;">
						<div class="value">
							<p class="tit">산화환원전위차</p>
							<div class="value-datas">
								<span id="data-03-01" class="val">-</span>
								<p class="unit"></p>
							</div>
						</div>
						<div class="value">
							<p class="tit">탁도</p>
							<div class="value-datas">
								<span id="data-03-02" class="val">-</span>
								<p class="unit"></p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="imgContents" class="area">
			<p class="area-title">공정 상세</p>
		</div>
	</div>
</body>
</html>