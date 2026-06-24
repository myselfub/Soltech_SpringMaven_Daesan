<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>폐수.탈취</title>
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
			"data-01-01" : "CDSWSS.LIT481A.F_CV",
			"data-01-02" : "CDSWSS.LIT481B.F_CV",
			"data-01-03" : "CDSWSS.FIT482.F_CV",
			"data-01-04" : "CDSWSS.PIT482.F_CV",
			"data-01-05" : "CDSWSS.LIT801.F_CV",
			"data-02-01" : "CDSWSS.LIT641A.F_CV",
			"data-02-02" : "CDSWSS.LIT641B.F_CV",
			"data-02-03" : "CDSWSS.M702A_RUN_STS.F_CV",
			"data-02-04" : "CDSWSS.M702B_RUN_STS.F_CV",
			"data-02-05" : "CDSWSS.M702C_RUN_STS.F_CV",
			"data-02-06" : "CDSWSS.FIT641A.F_CV",
			"data-02-07" : "CDSWSS.FIT641B.F_CV",
			"data-02-08" : "CDSWSS.M701A_RUN_STS.F_CV",
			"data-02-09" : "CDSWSS.M701B_RUN_STS.F_CV",
			"data-02-10" : "CDSWSS.M701C_RUN_STS.F_CV",
			"data-03-01" : "CDSWSS.PH641A.F_CV",
			"data-03-02" : "CDSWSS.PH641B.F_CV",
			"data-03-03" : "CDSWSS.LIT641A.F_CV",
			"data-03-04" : "CDSWSS.LIT641B.F_CV",
			"data-03-05" : "CDSWSS.LIT643A.F_CV",
			"data-03-06" : "CDSWSS.LIT643B.F_CV",
			"data-03-07" : "CDSWSS.LIT651.F_CV",
			"data-04-01" : "CDSWSS.LIT661A.F_CV",
			"data-04-02" : "CDSWSS.LIT661B.F_CV",
			"data-04-03" : "CDSWSS.FIT661A.F_CV",
			"data-04-04" : "CDSWSS.FIT661B.F_CV",
			"data-04-05" : "CDSWSS.FIT661C.F_CV",
			"data-04-06" : "CDSWSS.PIT663A.F_CV",
			"data-04-07" : "CDSWSS.PIT663B.F_CV",
			"data-04-08" : "CDSWSS.PIT663C.F_CV",
			"data-04-09" : "CDSWSS.PIT663D.F_CV",
			"data-04-10" : "CDSWSS.LCP_803A.F_CV",
			"data-04-11" : "CDSWSS.LCP_803B.F_CV",
			"data-04-12" : "CDSWSS.LCP_803C.F_CV",
			"data-05-01" : "CDSWSS.FIT611.F_CV",
			"data-05-02" : "CDSWSS.M713A_RUN_STS.F_CV",
			"data-05-03" : "CDSWSS.M713B_RUN_STS.F_CV",
			"data-05-04" : "CDSWSS.FIT621A.F_CV",
			"data-05-05" : "CDSWSS.FIT621B.F_CV",
			"data-05-06" : "CDSWSS.M711A_RUN_STS.F_CV",
			"data-05-07" : "CDSWSS.M711B_RUN_STS.F_CV",
			"data-05-08" : "CDSWSS.M711C_RUN_STS.F_CV",
			"data-06-01" : "CDSWSS.M214A_RUN_STS.F_CV",
			"data-06-02" : "CDSWSS.M214B_RUN_STS.F_CV",
			"data-06-03" : "CDSWSS.M707A_RUN_STS.F_CV",
			"data-06-04" : "CDSWSS.M707B_RUN_STS.F_CV",
			"data-06-05" : "CDSWSS.M707C_RUN_STS.F_CV",
			"data-06-06" : "CDSWSS.M802A_RUN_STS.F_CV",
			"data-06-07" : "CDSWSS.M802B_RUN_STS.F_CV",
			"data-06-08" : "CDSWSS.M802C_RUN_STS.F_CV",
			"data-06-09" : "CDSWSS.M802D_RUN_STS.F_CV",
		};

		setDataAtt(dataObj.tagMapping, document);

		// SVG
		ajaxImg("PS.svg").then((emtSvg) => {
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
					<div class="title">주요 현황</div>
					<div class="values">
						<div class="value">
							<p class="tit" style="flex: 1;">생산 수조 수위</p>
							<div class="value-datas" style="flex: 1;">
								<span id="data-01-01" class="val">-</span>
								<p class="unit">m</p>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span id="data-01-02" class="val">-</span>
								<p class="unit">㎥/h</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">생산수 유출유량</p>
							<div class="value-datas">
								<span id="data-01-03" class="val">-</span>
								<p class="unit">㎥</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">생산수 유출압력</p>
							<div class="value-datas">
								<span id="data-01-04" class="val">-</span>
								<p class="unit">㎏/㎠</p>
							</div>
						</div>
						<div class="value">
							<p class="tit">방류수조 수위</p>
							<div class="value-datas">
								<span id="data-01-05" class="val">-</span>
								<p class="unit">m</p>
							</div>
						</div>
					</div>
				</div>
				<div class="data-box">
					<div class="title">폐수처리</div>
					<div class="values">
						<div class="value">
							<p class="tit" style="flex: 2;">폐수 유입 수조 수위</p>
							<div class="value-datas"
								style="flex: 1; justify-content: center;">
								<div class="value-datas">
									<span id="data-02-01" class="val">-</span>
									<p class="unit">m</p>
								</div>
							</div>
							<div class="value-datas"
								style="flex: 1; justify-content: center;">
								<div class="value-datas">
									<span id="data-02-02" class="val">-</span>
									<p class="unit">m</p>
								</div>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 2;">폐수공급펌프</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-03" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-04" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-05" class="off-img"></span>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 2;">폐수공급펌프 유출유량</p>
							<div class="value-datas"
								style="flex: 1; justify-content: center;">
								<div class="value-datas">
									<span id="data-02-06" class="val">-</span>
									<p class="unit">㎥/h</p>
								</div>
							</div>
							<div class="value-datas"
								style="flex: 1; justify-content: center;">
								<div class="value-datas">
									<span id="data-02-07" class="val">-</span>
									<p class="unit">%</p>
								</div>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 2;">폐수유입조 송풍기</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-08" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-09" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-02-10" class="off-img"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="data-box">
					<div class="title">폐수처리</div>
					<div class="values">
						<div class="value">
							<p class="tit" style="flex: 1;">급속교반기 수소이온농도</p>
							<div class="value-datas" style="flex: 1;">
								<span id="data-03-01" class="val">-</span>
								<p class="unit">Ph</p>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span id="data-03-02" class="val">-</span>
								<p class="unit">Ph</p>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">급속교반기조 수위</p>
							<div class="value-datas" style="flex: 1;">
								<span id="data-03-03" class="val">-</span>
								<p class="unit">%</p>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span id="data-03-04" class="val">-</span>
								<p class="unit">%</p>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">완속교반기조 수위</p>
							<div class="value-datas" style="flex: 1;">
								<span id="data-03-05" class="val">-</span>
								<p class="unit">%</p>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span id="data-03-06" class="val">-</span>
								<p class="unit">%</p>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1;">폐수처리조 수위</p>
							<div class="value-datas" style="flex: 1;">
								<span id="data-03-07" class="val">-</span>
								<p class="unit">%</p>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="real-data-box">
				<div class="data-box">
					<div class="title">탈수처리</div>
					<div class="values">
						<div class="value">
							<p class="tit" style="flex: 1.2;">혼합슬러지 저류조 수위</p>
							<div class="value-datas"
								style="flex: 1.5; justify-content: center;">
								<div class="value-datas">
									<span id="data-04-01" class="val">-</span>
									<p class="unit">m</p>
								</div>
							</div>
							<div class="value-datas"
								style="flex: 1.5; justify-content: center;">
								<div class="value-datas">
									<span id="data-04-02" class="val">-</span>
									<p class="unit">m</p>
								</div>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1.2;">탈수기 유입 유량</p>
							<div class="value-datas" style="flex: 1; justify-content: end;">
								<div class="value-datas">
									<span id="data-04-03" class="val">-</span>
									<p class="unit">㎥/h</p>
								</div>
							</div>
							<div class="value-datas" style="flex: 1; justify-content: end;">
								<div class="value-datas">
									<span id="data-04-04" class="val">-</span>
									<p class="unit">㎥/h</p>
								</div>
							</div>
							<div class="value-datas" style="flex: 1; justify-content: end;">
								<div class="value-datas">
									<span id="data-04-05" class="val">-</span>
									<p class="unit">㎥/h</p>
								</div>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1.2;">가압세정수 유출압력</p>
							<div class="value-datas"
								style="flex: 0.75; justify-content: end;">
								<div class="value-datas">
									<span id="data-04-06" class="val">-</span>
									<p class="unit">bar</p>
								</div>
							</div>
							<div class="value-datas"
								style="flex: 0.75; justify-content: end;">
								<div class="value-datas">
									<span id="data-04-07" class="val">-</span>
									<p class="unit">bar</p>
								</div>
							</div>
							<div class="value-datas"
								style="flex: 0.75; justify-content: end;">
								<div class="value-datas">
									<span id="data-04-08" class="val">-</span>
									<p class="unit">bar</p>
								</div>
							</div>
							<div class="value-datas"
								style="flex: 0.75; justify-content: end;">
								<div class="value-datas">
									<span id="data-04-09" class="val">-</span>
									<p class="unit">bar</p>
								</div>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1.2;">탈수슬러지 저장호퍼</p>
							<div class="value-datas" style="flex: 1; justify-content: end;">
								<div class="value-datas">
									<span id="data-04-10 class="val">-</span>
									<p class="unit">ton</p>
								</div>
							</div>
							<div class="value-datas" style="flex: 1; justify-content: end;">
								<div class="value-datas">
									<span id="data-04-11" class="val">-</span>
									<p class="unit">ton</p>
								</div>
							</div>
							<div class="value-datas" style="flex: 1; justify-content: end;">
								<div class="value-datas">
									<span id="data-04-12" class="val">-</span>
									<p class="unit">ton</p>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="data-box">
					<div class="title">FeCI 투입현황</div>
					<div class="values">
						<div class="value">
							<p class="tit" style="flex: 2;">FeCI 유출유량</p>
							<div class="value-datas"
								style="flex: 3; justify-content: center;">
								<div class="value-datas">
									<span id="data-05-01" class="val">-</span>
									<p class="unit">㎥/h</p>
								</div>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 2;">FeCI 주입펌프</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-05-02" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-05-03" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;"></div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 2;">폴리머 유출유량</p>
							<div class="value-datas"
								style="flex: 3; justify-content: center;">
								<div class="value-datas">
									<span id="data-05-04" class="val">-</span>
									<p class="unit">㎥/h</p>
								</div>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 2;">폴리머 주입펌프</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-05-05" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-05-06" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-05-07" class="off-img"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="data-box">
					<div class="title">폴리머 주입 현황</div>
					<div class="values">
						<div class="value">
							<p class="tit" style="flex: 1.5;"></p>
							<div class="value-datas" style="flex: 1;">
								<span class="val" style="text-align: center;">A</span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val" style="text-align: center;">B</span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val" style="text-align: center;">C</span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val" style="text-align: center;">D</span>
							</div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1.5;">부상슬러지 이송펌프</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-06-01" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-06-02" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;"></div>
							<div class="value-datas" style="flex: 1;"></div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1.5;">폐수슬러지 이송펌프</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-06-03" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-06-04" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-06-05" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;"></div>
						</div>
						<div class="value">
							<p class="tit" style="flex: 1.5;">폐수슬러지 이송펌프</p>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-06-06" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-06-07" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-06-08" class="off-img"></span>
							</div>
							<div class="value-datas" style="flex: 1;">
								<span class="val"><img id="data-06-09" class="off-img"></span>
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