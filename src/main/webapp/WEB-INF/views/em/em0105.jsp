<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ page session="true"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전체 전력 현황</title>
<script src="resources/js/echarts/echarts.min.js"></script>
<style>
.layoutBox_m {
	background: #283952;
}

.main-title {
	color: #FFFFFF;
}

.flex-row-10 {
	display: flex;
	column-gap: 10px;
}

.flex-col-10 {
	display: flex;
	flex-direction: column;
	row-gap: 0.65rem;
}

.grid-col2-row2-10 {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	column-gap: 0.65rem;
	row-gap: 0.65rem;
}

.tot-val-box {
	width: 100%;
	height: 100%;
	justify-content: center;
	padding: 0 1.3rem;
}

.tot-val-box .val-box {
	height: auto;
	justify-content: end;
}

.tot-title {
	color: #FFFFFF;
	font-size: 1.35rem;
	border-bottom: 1px solid #FFFFFF;
	text-wrap: nowrap;
}

.tot-val {
	color: #FFFFFF;
	font-size: 1.7rem;
}

.tot-unit {
	color: #FFFFFF;
	font-size: 1.25rem;
	display: flex;
	justify-content: end;
	flex-direction: column;
}

.img-procs {
	width: 120px;
	height: 120px;
}

.procs-box {
	border: 1px solid #F7F7F7;
	border-radius: 10px;
	background: #F7F7F7;
	width: 25.85rem
}

.procs-box .nametag-box {
	padding: 10px;
	background: #293347;
	border: 2px solid #F7F7F7;
	border-radius: 10px;
	cursor: pointer;
	row-gap: 0;
}

.procs-title {
	text-align: center;
	color: #FFFFFF;
}

.procs-box .val-group-box {
	padding: 0.65rem;
}

.procs-valbox .title {
	font-size: 1rem;
	border-bottom: 1px solid #293347;
	white-space: nowrap;
}

.procs-valbox .title>.max-time {
	font-size: 0.75rem;
	font-weight: bold;
	color: #EE3333;
}

.procs-valbox .val-box {
	justify-content: end;
	height: auto;
}

.procs-valbox .val {
	font-size: 1.35rem;
}

.procs-valbox .unit {
	display: flex;
	flex-direction: column;
	justify-content: center;
	font-size: 0.85rem;
}
</style>
</head>
<body>
	<div id="main" class="main-contents-grid1" style="height: 100%;">
		<div class="main-title">전체 전력 현황</div>
		<div class="main-contents-grid1"
			style="flex: 1 1 0; row-gap: 1.25rem;">
			<div class="main-contents-grid2"
				style="height: 100%; flex-basis: 40%">
				<!-- 전체 현황 -->
				<div class="flex-col-10"
					style="flex-basis: 25%; padding: 0 0.65rem;">
					<div class="flex-row-10" style="height: 100%;">
						<div class="flex-col-10 tot-val-box">
							<div class="tot-title">실시간 전력</div>
							<div class="flex-row-10 val-box">
								<div class="tot-val" id="TOT_RT_PWRER">-</div>
								<div class="tot-unit">KW</div>
							</div>
						</div>
						<div class="flex-col-10 tot-val-box">
							<div class="tot-title">
								금일 최대(<span id="TOT_MAX_TIME">00</span>시)
							</div>
							<div class="flex-row-10 val-box">
								<div class="tot-val" id="TOT_MAX">-</div>
								<div class="tot-unit">KW</div>
							</div>
						</div>
					</div>
					<div class="flex-row-10" style="height: 100%;">
						<div class="flex-col-10 tot-val-box">
							<div class="tot-title">금일 소비 전력량</div>
							<div class="flex-row-10 val-box">
								<div class="tot-val" id="TOT_USG">-</div>
								<div class="tot-unit">MWh</div>
							</div>
						</div>
						<div class="flex-col-10 tot-val-box">
							<div class="tot-title">금일 소비 요금</div>
							<div class="flex-row-10 val-box">
								<div class="tot-val" id="TOT_PRC">-</div>
								<div class="tot-unit">원</div>
							</div>
						</div>
					</div>
					<div class="flex-row-10" style="height: 100%;">
						<div class="flex-col-10 tot-val-box">
							<div class="tot-title">CO₂ 저감량</div>
							<div class="flex-row-10 val-box">
								<div class="tot-val" id="TOT_CO2">-</div>
								<div class="tot-unit">Ton</div>
							</div>
						</div>
						<div class="flex-col-10 tot-val-box">
							<div class="tot-title">태양광 전력량</div>
							<div class="flex-row-10 val-box">
								<div class="tot-val" id="TOT_SUN">-</div>
								<div class="tot-unit">kWh</div>
							</div>
						</div>
					</div>
				</div>

				<!-- 공정별 현황 -->
				<div id="procsSttsBox" class="flex-col-10"
					style="flex-basis: 75%; padding: 0 0.65rem;">
					<!-- init 함수에서 db 조회하여 넣음 -->
				</div>
			</div>
			<div class="main-contents-grid2" style="flex-basis: 50%">
				<div class="flex-col-10"
					style="width: 100%; height: 100%; justify-content: center;">
					<div class="flex-row-10" style="align-items:center;">
						<div style="color: #FFFFFF; font-size: 20px;">누적 전력량</div>
						<select id="type_chart1" style="min-width: 6rem;">
							<option value="ALL">전체</option>
							<option value="PROCS_1">취수장</option>
							<option value="PLANT">플랜트</option>
						</select>
						<label style="color: #FFFFFF;">
							<input type="radio" name="rdo_chart1"
								style="vertical-align: middle;" checked>
							금일
						</label>
						<label style="color: #FFFFFF;">
							<input type="radio" name="rdo_chart1"
								style="vertical-align: middle;">
							일별
						</label>
						<label style="color: #FFFFFF;">
							<input type="radio" name="rdo_chart1"
								style="vertical-align: middle;">
							월별
						</label>
						<label style="color: #FFFFFF;">
							<input type="radio" name="rdo_chart1"
								style="vertical-align: middle;">
							년도별
						</label>
					</div>
					<div style="width: 100%; height: 300px;" id="chart1"></div>
				</div>
				<div class="flex-col-10"
					style="width: 100%; height: 100%; justify-content: center;">
					<div class="flex-row-10" style="align-items: center;">
						<div style="color: #FFFFFF; font-size: 20px;">소비 요금</div>
						<div>
							<select id="type_chart2" style="min-width: 6rem;">
								<option value="ALL">전체</option>
								<option value="PROCS_1">취수장</option>
								<option value="PLANT">플랜트</option>
							</select>
						</div>
						<label style="color: #FFFFFF;">
							<input type="radio" name="rdo_chart2"
								style="vertical-align: middle;" checked>
							금일
						</label>
						<label style="color: #FFFFFF;">
							<input type="radio" name="rdo_chart2"
								style="vertical-align: middle;">
							일별
						</label>
						<label style="color: #FFFFFF;">
							<input type="radio" name="rdo_chart2"
								style="vertical-align: middle;">
							월별
						</label>
						<label style="color: #FFFFFF;">
							<input type="radio" name="rdo_chart2"
								style="vertical-align: middle;">
							년도별
						</label>
					</div>
					<div style="width: 100%; height: 300px;" id="chart2"></div>
				</div>
				<div class="flex-col-10"
					style="width: 100%; height: 100%; justify-content: center;">
					<div class="flex-row-10">
						<div style="color: #FFFFFF; font-size: 20px;">CO₂ 저감량</div>
						<label style="color: #FFFFFF;">
							<input type="radio" name="rdo_chart3"
								style="vertical-align: middle; margin-right: 0.65rem;" checked>
							금일
						</label>
						<label style="color: #FFFFFF;">
							<input type="radio" name="rdo_chart3"
								style="vertical-align: middle; margin-right: 0.65rem;">
							일별
						</label>
						<label style="color: #FFFFFF;">
							<input type="radio" name="rdo_chart3"
								style="vertical-align: middle; margin-right: 0.65rem;">
							월별
						</label>
						<label style="color: #FFFFFF;">
							<input type="radio" name="rdo_chart3"
								style="vertical-align: middle; margin-right: 0.65rem;">
							년도별
						</label>
					</div>
					<div style="width: 100%; height: 300px;" id="chart3"></div>
				</div>
			</div>
		</div>
	</div>
	<script>
		let dataObj = {};
		window.onload = async function() {
			if (dataObj) {
				dataObj.isEvent = false;
				dataObj.eventTime = 10;
				dataObj.timeOutTime = 5;
				dataObj.timeOutId = null;
				dataObj.refreshInterval = 30;  // 30초 갱신 주기
			} else {
				window.dataObj = {
					isEvent: false,
					eventTime: 10,
					timeOutTime: 5,
					timeOutId: null,
					refreshInterval: 30
				};
			}

			// em0104 시간대 설정 먼저 로드
			await getPwrerUntMngData();

			init();
			dataObj.chart1 = initPwrerChart("chart1", "누적 전력량", "MWh");
			dataObj.chart2 = initPriceChart("chart2", "소비 요금", "원");
			dataObj.chart3 = initChart3("chart3");

			// 차트 데이터 로드 (각 차트 독립적으로)
			loadPowerUsageChartData("today", "ALL");
			loadCostChartData("today", "ALL");
			loadCO2ChartData("today");

			// 누적 전력량 차트(chart1) 라디오 버튼 이벤트
			$("input[name='rdo_chart1'], #type_chart1").on("change", function() {
				let idx = $("input[name='rdo_chart1']").index($("input[name='rdo_chart1']:checked"));
				let period = ["today", "daily", "monthly", "yearly"][idx];
				let type = $("#type_chart1").val();
				
				loadPowerUsageChartData(period, type);
			});

			// 소비 요금 차트(chart2) 라디오 버튼 이벤트
			$("input[name='rdo_chart2'], #type_chart2").on("change", function() {
				let idx = $("input[name='rdo_chart2']").index($("input[name='rdo_chart2']:checked"));
				let period = ["today", "daily", "monthly", "yearly"][idx];
				let type = $("#type_chart2").val();
				
				loadCostChartData(period, type);
			});

			// CO2 차트(chart3) 라디오 버튼 이벤트
			$("input[name='rdo_chart3']").on("change", function() {
				let idx = $("input[name='rdo_chart3']").index(this);
				let period = ["today", "daily", "monthly", "yearly"][idx];
				loadCO2ChartData(period);
			});

			getPorcsElecValues();
			getProcsUsgValues();

			// 시설별 전력 데이터 조회 (DB 기반)
 			getFacilityPowerData();

			// CO2 저감량 및 태양광 전력량 조회 (DB 기반)
			updateSolarData();

			// CO2 저감량 차트 데이터 로드
			loadCO2ChartData();

			// 5초마다 전체 데이터 갱신 (DB 기반)
			setInterval(function() {
				console.log("========== 5초 주기 데이터 갱신 ==========");
				refreshAllData();
			}, 500 * 1000);
		};

		// 전체 데이터 갱신 함수 (5초 주기)
		function refreshAllData() {
			// 1. 실시간 전력 조회
			getRealTimePowerFromDB().then((res) => {
				if (res && res.length > 0) {
					let totalRtPower = 0;
					let procsPower = {};

					res.forEach(tag => {
						let val = Number(tag.VAL) || 0;
						let procsId = tag.PROCS_ID;
						totalRtPower += val;
						if (!procsPower[procsId]) procsPower[procsId] = 0;
						procsPower[procsId] += val;
					});

					$("#TOT_RT_PWRER").text(totalRtPower.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ","));
					for (let procsId in procsPower) {
						$("#" + procsId + "_RT_PWRER").text(procsPower[procsId].toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ","));
					}
				} else {
					console.log("실시간 전력 데이터 없음");
				}
			}).catch((err) => {
				console.error("실시간 전력 갱신 실패:", err);
			});

			// 2. 금일 최대 전력 조회
			getTodayMaxPower();

			// 3. 금일 소비 전력량 조회 // 4번에서 통합
// 			getTodayPwrerUsage();

			// 4. 금일 소비 요금 조회
			getTodayPowerCost();

			// 5. 차트 데이터 갱신 (각 차트 현재 선택된 기간)
			let periods = ["today", "daily", "monthly", "yearly"];
			let idx1 = $("input[name='rdo_chart1']").index($("input[name='rdo_chart1']:checked"));
			let idx2 = $("input[name='rdo_chart2']").index($("input[name='rdo_chart2']:checked"));
			let idx3 = $("input[name='rdo_chart3']").index($("input[name='rdo_chart3']:checked"));
			
			let type1 = $("#type_chart1").val() || "all"
			let type2 = $("#type_chart2").val() || "all"
			
			loadPowerUsageChartData(periods[idx1] || "today", type2);
			loadCostChartData(periods[idx2] || "today", type2);
			loadCO2ChartData(periods[idx3] || "today");

			// 6. 시설별 전력 데이터 갱신 // 4번에서 통합
			getFacilityPowerData();

			// 7. CO2 저감량 및 태양광 전력량 갱신
			updateSolarData();

			// 8. CO2 차트 데이터 갱신
			loadCO2ChartData();
		}

		function loadProcsEmPage(procs_id) {
			window.location.href="em0103?procs=" + (procs_id.replace("PROCS_", "contents"));
		};

		// ============================================
		// Tibero DB 조회 함수 (iHistorian 대체)
		// ============================================

		// 실시간 전력 조회 (DB)
		function getRealTimePowerFromDB() {
			let date = moment().format("YYYYMMDD");
			return new Promise((resolve, reject) => {
				$.ajax({
					type: "POST",
					contentType: "application/json; charset=UTF-8",
					url: "getRealTimePower",
					dataType: "json",
					cache: false,
					data: JSON.stringify({ date: date }),
					success: function(res) {
						resolve(res);
					},
					error: function(e) {
						console.error("실시간 전력 조회 실패:", e);
						reject(e);
					}
				});
			});
		}

		// 금일 전력량 조회 (DB)
		function getTodayPowerUsageFromDB() {
			let date = moment().format("YYYYMMDD");
			return new Promise((resolve, reject) => {
				$.ajax({
					type: "POST",
					contentType: "application/json; charset=UTF-8",
					url: "getTodayPowerUsage",
					dataType: "json",
					cache: false,
					data: JSON.stringify({ date: date }),
					success: function(res) {
						resolve(res);
					},
					error: function(e) {
						console.error("금일 전력량 조회 실패:", e);
						reject(e);
					}
				});
			});
		}

		// 금일 최대 전력 조회 (DB)
		function getTodayMaxPowerFromDB() {
			let date = moment().format("YYYYMMDD");
			return new Promise((resolve, reject) => {
				$.ajax({
					type: "POST",
					contentType: "application/json; charset=UTF-8",
					url: "getTodayMaxPower",
					dataType: "json",
					cache: false,
					data: JSON.stringify({ date: date }),
					success: function(res) {
						resolve(res);
					},
					error: function(e) {
						console.error("금일 최대 전력 조회 실패:", e);
						reject(e);
					}
				});
			});
		}

		// 시간별 전력량 조회 (DB - 차트용)
		function getHourlyPowerDataFromDB(startTime, endTime) {
			return new Promise((resolve, reject) => {
				$.ajax({
					type: "POST",
					contentType: "application/json; charset=UTF-8",
					url: "getHourlyPowerData",
					dataType: "json",
					cache: false,
					data: JSON.stringify({ startTime: startTime, endTime: endTime }),
					success: function(res) {
						resolve(res);
					},
					error: function(e) {
						console.error("시간별 전력량 조회 실패:", e);
						reject(e);
					}
				});
			});
		}

		// ============================================
		// CO2 저감량 / 태양광 전력량 DB 조회 함수
		// ============================================

		// CO2 저감량 조회 (DB - RDITAG_TB의 COM_SOLAR_CO2_RED)
		function getCO2ReductionFromDB() {
			let date = moment().format("YYYYMMDD");
			return new Promise((resolve, reject) => {
				$.ajax({
					type: "POST",
					contentType: "application/json; charset=UTF-8",
					url: "getSolarTagValue",
					dataType: "json",
					cache: false,
					data: JSON.stringify({ date: date, tagNm: "COM_SOLAR_CO2_RED" }),
					success: function(res) {
						resolve(res);
					},
					error: function(e) {
						console.error("CO2 저감량 조회 실패:", e);
						reject(e);
					}
				});
			});
		}

		// 태양광 금일발전량 조회 (DB - RDITAG_TB의 COM_SOLAR_DAY_AE)
		function getSolarPowerFromDB() {
			let date = moment().format("YYYYMMDD");
			return new Promise((resolve, reject) => {
				$.ajax({
					type: "POST",
					contentType: "application/json; charset=UTF-8",
					url: "getSolarTagValue",
					dataType: "json",
					cache: false,
					data: JSON.stringify({ date: date, tagNm: "COM_SOLAR_DAY_AE" }),
					success: function(res) {
						resolve(res);
					},
					error: function(e) {
						console.error("태양광 금일발전량 조회 실패:", e);
						reject(e);
					}
				});
			});
		}

		// CO2 저감량 시간별 데이터 조회 (차트용)
		function getHourlyCO2DataFromDB() {
			let date = moment().format("YYYYMMDD");
			return new Promise((resolve, reject) => {
				$.ajax({
					type: "POST",
					contentType: "application/json; charset=UTF-8",
					url: "getHourlySolarData",
					dataType: "json",
					cache: false,
					data: JSON.stringify({ date: date, tagNm: "COM_SOLAR_CO2_RED" }),
					success: function(res) {
						resolve(res);
					},
					error: function(e) {
						console.error("CO2 저감량 시간별 데이터 조회 실패:", e);
						reject(e);
					}
				});
			});
		}

		// CO2 저감량 및 태양광 전력량 표시 업데이트
		function updateSolarData() {
			// CO2 저감량 조회
			getCO2ReductionFromDB().then((res) => {
				if (res && res.length > 0) {
					let co2Val = Number(res[0].VAL) || 0;
					console.log("CO2 저감량:", co2Val, "Ton");
					$("#TOT_CO2").text(co2Val.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ","));
				} else {
					$("#TOT_CO2").text("-");
				}
			}).catch((err) => {
				console.error("CO2 저감량 표시 실패:", err);
				$("#TOT_CO2").text("-");
			});

			// 태양광 금일발전량 조회
			getSolarPowerFromDB().then((res) => {
				if (res && res.length > 0) {
					let solarVal = Number(res[0].VAL) || 0;
					console.log("태양광 금일발전량:", solarVal.toFixed(2), "MWh");
					$("#TOT_SUN").text(solarVal.toFixed(2));
				} else {
					$("#TOT_SUN").text("-");
				}
			}).catch((err) => {
				console.error("태양광 금일발전량 표시 실패:", err);
				$("#TOT_SUN").text("-");
			});
		}

		// iHistorian 호출 함수 (기존 유지 - 폴백용)
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
					} else if (emt.tagName && (emt.tagName.toLowerCase() == "div" || emt.tagName.toLowerCase() == "span")) {
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

		async function init() {
			let procs_list = await getProcInfoList(undefined, "data");
			let appendTxt = "";
			for (let idx in procs_list) {
				if (Number(idx) % 3 == 0) {
					if (Number(idx) != 0) {
						appendTxt += "</div>";
					}
					appendTxt += "<div class='flex-row-10' style='justify-content: space-around; flex: 1 1 0;'>";
				}
				let procs = procs_list[idx];
				appendTxt += `
					<div class="flex-row-10 procs-box">
						<div class="flex-col-10 nametag-box" onclick="loadProcsEmPage('\${procs.PROCS_ID}');">
							<img class="img-procs" src="resources/images/view/em/em0105/\${procs.PROCS_ID}.png">
							<p class="procs-title">\${procs.PROCS_NM}</p>
						</div>
						<div class="grid-col2-row2-10 val-group-box">
							<div class="flex-col-10 procs-valbox">
								<div class="title">실시간 전력</div>
								<div class="flex-row-10 val-box">
									<div class="val" id="\${procs.PROCS_ID}_RT_PWRER">-</div>
									<div class="unit">KW</div>
								</div>
							</div>
							<div class="flex-col-10 procs-valbox">
								<div class="title">금일 최대(<span id="\${procs.PROCS_ID}_MAXTIME" class="max-time">00</span>시)</div>
								<div class="flex-row-10 val-box">
									<div class="val" id="\${procs.PROCS_ID}_MAX">-</div>
									<div class="unit">KW</div>
								</div>
							</div>
							<div class="flex-col-10 procs-valbox">
								<div class="title">소비 전력량</div>
								<div class="flex-row-10 val-box">
									<div class="val" id="\${procs.PROCS_ID}_USG">-</div>
									<div class="unit">MWh</div>
								</div>
							</div>
							<div class="flex-col-10 procs-valbox">
								<div class="title">소비 요금</div>
								<div class="flex-row-10 val-box">
									<div class="val" id="\${procs.PROCS_ID}_PRC">-</div>
									<div class="unit">원</div>
								</div>
							</div>
						</div>
					</div>
				`;
			}
			$("#procsSttsBox").append(appendTxt);

			// 폐탈수처리에 포함된 공정 표시 (생산수/공급, 농축수.방류, 관로(취송수))
			// PROCS_6(폐탈수처리)은 실제 전력 값을 표시하므로 제외
			$('.procs-title').each(function() {
				let title = $(this).text().trim();
				let onclick = $(this).closest('.nametag-box').attr('onclick') || '';
				let procsId = (onclick.match(/PROCS_\d+/) || [''])[0];
				if (procsId === 'PROCS_7' || procsId === 'PROCS_2') return;
				if (title.includes('생산수') || title.includes('농축수') || title.includes('방류') || title.includes('관로')) {
					$(this).closest('.procs-box').find('.val-group-box')
						.css({display: 'flex', alignItems: 'center', justifyContent: 'center'})
						.html('<div style="font-size: 14px; color: #000; font-weight: bold;">폐탈수처리에 포함됨</div>');
				}
			});

			// 금일 소비 전력량 계산용 태그
			// TAG_NM: COM_EHV101_1_AE, COM_EHV101_2_AE, COM_EHV401_1_AE, COM_EHV401_2_AE
			dataObj.pwrerSumTags = [
				"CDSWSS.COM_EHV101_1_AE.F_CV",
				"CDSWSS.COM_EHV101_2_AE.F_CV",
				"CDSWSS.COM_EHV401_1_AE.F_CV",
				"CDSWSS.COM_EHV401_2_AE.F_CV"
			];

			// 실시간 전력 태그 매핑 (iHistorian 폴백용)
			// TAG_NM: COM_EHV101_1_ACTI, COM_EHV101_2_ACTI, COM_EHV401_1_ACTI, COM_EHV401_2_ACTI
			dataObj.tagMapping = {
				"TOT_RT_PWRER" : "SUM(CDSWSS.COM_EHV101_1_ACTI.F_CV,CDSWSS.COM_EHV101_2_ACTI.F_CV,"
					+ "CDSWSS.COM_EHV401_1_ACTI.F_CV,CDSWSS.COM_EHV401_2_ACTI.F_CV)",
				"PROCS_1_RT_PWRER" : "SUM(CDSWSS.COM_EHV101_1_ACTI.F_CV,CDSWSS.COM_EHV101_2_ACTI.F_CV)",
				"PROCS_2_RT_PWRER" : "CDSWSS.COM_MCC701H_ACTI.F_CV",
				"PROCS_3_RT_PWRER" : "SUM(CDSWSS.COM_HV403_DN_ACTI.F_CV,CDSWSS.COM_HV406_DN_ACTI.F_CV)",
				"PROCS_4_RT_PWRER" : "SUM(CDSWSS.COM_HV403_UP_ACTI.F_CV,CDSWSS.COM_HV406_UP_ACTI.F_CV)",
				"PROCS_5_RT_PWRER" : "SUM(CDSWSS.COM_HV402_UP_ACTI.F_CV,CDSWSS.COM_HV402_DN_ACTI.F_CV,CDSWSS.COM_HV405_UP_ACTI.F_CV,CDSWSS.COM_HV405_DN_ACTI.F_CV)",
				"PROCS_6_RT_PWRER" : "CDSWSS.TODO.F_CV",
				"PROCS_7_RT_PWRER" : "SUM(CDSWSS.COM_MCC601A_ACTI.F_CV,CDSWSS.COM_MCC601B_ACTI.F_CV,CDSWSS.COM_MCC601C_ACTI.F_CV,CDSWSS.COM_MCC601D_ACTI.F_CV,CDSWSS.COM_MCC601H_ACTI.F_CV,CDSWSS.COM_EMCC601_ACTI.F_CV)",
				"PROCS_8_RT_PWRER" : "CDSWSS.TODO.F_CV",
				"PROCS_9_RT_PWRER" : "CDSWSS.TODO.F_CV",
			};
			setDataAtt(dataObj.tagMapping, document);

			// 금일 소비 전력량 조회 (Tibero DB)
// 			getTodayPwrerUsage();

			// 실시간 전력 조회 (Tibero DB)
			getRealTimePowerFromDB().then((res) => {
				if (res && res.length > 0) {
					console.log("========== 실시간 전력 조회 (DB) ==========");

					// 전체 실시간 전력 합계
					let totalRtPower = 0;
					let procsPower = {};  // PROCS_ID별 전력 합계

					res.forEach(tag => {
						let val = Number(tag.VAL) || 0;
						let procsId = tag.PROCS_ID;

						console.log("  " + tag.TAG_ALIAS + " (" + tag.TAG_ADD_DC + "): " + val + " KW [" + procsId + "]");

						totalRtPower += val;

						if (!procsPower[procsId]) procsPower[procsId] = 0;
						procsPower[procsId] += val;
					});

					console.log("---------- 전체 합계 ----------");
					console.log("  TOT_RT_PWRER: " + totalRtPower + " KW");

						// 전체 실시간 전력 표시 (소수점 2자리)
					$("#TOT_RT_PWRER").text(totalRtPower.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ","));

					// 공정별 실시간 전력 표시 (소수점 2자리)
					for (let procsId in procsPower) {
						console.log("  " + procsId + "_RT_PWRER: " + procsPower[procsId] + " KW");
						$("#" + procsId + "_RT_PWRER").text(procsPower[procsId].toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ","));
					}
					console.log("==========================================");
				} else {
					console.log("DB 데이터 없음");
				}
			}).catch((err) => {
				console.error("실시간 전력 조회 실패:", err);
			});
		};

		// iHistorian에서 실시간 전력 조회 (폴백용)
		function loadRealTimePowerFromHistorian() {
			ajaxData(Object.values(dataObj.tagMapping)).then((res) => {
				if (res) {
					res.param.forEach(item => {
						let emts = document.querySelectorAll("[data-tag='" + item.name + "']");
						if (emts.length == 0) {
							emts = document.querySelectorAll("[data-tag$='" + item.name + ")']");
							if (emts.length == 0) {
								emts = document.querySelectorAll("[data-tag*='" + item.name + "']");
							}
						}
						emts.forEach(emt => {
							if ((emt.tagName && emt.tagName.toLowerCase() == "span")
								|| (emt.tagName && emt.tagName.toLowerCase() == "div")) {
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
		}

		function getPorcsElecValues() {
			let date = moment().format("YYYYMMDD");
			$.ajax ({
				type: "POST",
				contentType: "application/json; charset=utf-8",
				cache : false,
				url: "getGridStatisticsData",
				dataType: "json",
				data: JSON.stringify({date: date}),
				success: function(data) {
					let facilityProcsIds = new Set(Object.values(FACILITY_TO_PROCS));
					for (let d of data) {
						if (facilityProcsIds.has(d.PROCS_ID)) continue;
						let maxVal = d.MAX;
						if (maxVal && maxVal !== '-') {
							let numVal = Number(String(maxVal).replace(/,/g, ''));
							if (!isNaN(numVal)) {
								$("#" + d.PROCS_ID + "_MAX").text(numVal.toLocaleString("ko-KR"));
							} else {
								$("#" + d.PROCS_ID + "_MAX").text("-");
							}
						} else {
							$("#" + d.PROCS_ID + "_MAX").text("-");
						}
					}
				},
				error: function(err) {
					console.error("공정별 최대 전력 조회 실패:", err);
				}
			});

			// 금일 최대 전력 (실시간 전력 합계의 금일 최대값) 조회
			getTodayMaxPower();
		};

		// 금일 실시간 전력 중 최대값 조회 (Tibero DB)
		function getTodayMaxPower() {
			let date = moment().format("YYYYMMDD");

			console.log("========== 금일 최대 전력 조회 (DB) ==========");
			console.log("조회 날짜:", date);

			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "getTodayMaxPower",
				dataType: "json",
				cache: false,
				data: JSON.stringify({ date: date }),
				success: function(res) {
					console.log("금일 최대 전력 응답 데이터:", res);

					if (!res || res.length === 0) {
						console.log("데이터 없음");
						$("#TOT_MAX").text("-");
						$("#TOT_MAX_TIME").text("00");
						return;
					}

					let data = res[0];
					let maxPower = Number(data.MAX_POWER) || 0;
					let maxHour = data.MAX_HOUR || "00";

					console.log("금일 최대 전력:", maxPower, "KW (시간:", maxHour, "시)");
					console.log("==========================================");

					$("#TOT_MAX").text(maxPower > 0 ? maxPower.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ",") : "-");
					$("#TOT_MAX_TIME").text(maxHour);
				},
				error: function(xhr, status, err) {
					console.error("금일 최대 전력 조회 실패:");
					console.error("- status:", status);
					console.error("- error:", err);
					$("#TOT_MAX").text("-");
					$("#TOT_MAX_TIME").text("00");
				}
			});
		}

		function getProcsUsgValues(){
			let date = moment().format("YYYYMMDD");
			$.ajax ({
				type: "POST",
				contentType: "application/json; charset=utf-8",
				cache : false,
				url: "getGridPwereUsgPrc",
				dataType: "json",
				data: JSON.stringify({date: date}),
				success: function(data) {
					let facilityProcsIds = new Set(Object.values(FACILITY_TO_PROCS));
					let prc = 0;
					for(let d of data){
						if (facilityProcsIds.has(d.PROCS_ID)) continue;
						$("#" + d.PROCS_ID + "_USG").text(d.USG);
						$("#" + d.PROCS_ID + "_PRC").text(d.PRC);
						prc += Number((d.PRC).replaceAll(",", ""));
					}
					// 공정별 요금 합계는 DB 조회값 사용
					// 전체 요금은 getTodayPowerCost()에서 계산
				}
			});

			// 금일 소비 요금 계산
			getTodayPowerCost();
		};

		// 전력 단가 정보 (원/kWh) - 한국전력 산업용전력(갑)II 고압A 선택I (2025.04 시행)
		const POWER_PRICE = {
			// 여름철 (6~8월)
			S: { 1: 95.7, 2: 121.5, 3: 155.0 },   // 경부하, 중간부하, 최대부하
			// 봄가을철 (3~5, 9~10월)
			F: { 1: 95.7, 2: 100.5, 3: 119.7 },
			// 겨울철 (11~2월)
			W: { 1: 103.1, 2: 120.0, 3: 149.4 }
		};

		// 시간대별 부하구분 (1=경부하, 2=중간부하, 3=최대부하) - em0104 데이터로 동적 로드
		let LOAD_TYPE_BY_HOUR = null;

		// em0104 시간대 설정 데이터 조회
		function getPwrerUntMngData() {
			return new Promise((resolve, reject) => {
				let year = new Date().getFullYear();
				$.ajax({
					type: 'POST',
					contentType: 'application/json; charset=utf-8',
					cache: false,
					url: 'getPwrerUntMng',
					data: JSON.stringify({ year: year }),
					success: function(res) {
						LOAD_TYPE_BY_HOUR = { S: [], F: [], W: [] };
						for (let r of res) {
							let ptm = r.APLCN_PTM_CD; // S, F, W
							for (let h = 0; h < 24; h++) {
								let hourKey = "DATA_SE_CD_" + String(h).padStart(2, "0");
								let lv = Number(r[hourKey]) || 0;
								LOAD_TYPE_BY_HOUR[ptm][h] = lv;
							}
						}
						console.log("시간대 설정 로드 완료:", LOAD_TYPE_BY_HOUR);
						resolve();
					},
					error: function(e) {
						console.error("시간대 설정 조회 실패, 기본값 사용");
						// 기본값 설정
						LOAD_TYPE_BY_HOUR = {
							S: [1,1,1,1,1,1, 1,1,2,2,2,3, 2,3,3,3,3,3, 2,2,2,2,1,1],
							F: [1,1,1,1,1,1, 1,1,2,2,2,3, 2,3,3,3,3,3, 2,2,2,2,1,1],
							W: [1,1,1,1,1,1, 1,1,2,3,3,3, 2,2,2,2,3,3, 3,2,2,2,1,1]
						};
						resolve();
					}
				});
			});
		}

		// 월별 계절 구분
		function getSeason(month) {
			if (month >= 6 && month <= 8) return 'S';      // 여름
			if (month >= 11 || month <= 2) return 'W';    // 겨울
			return 'F';                                    // 봄가을
		}

		// 금일 소비 요금 계산 (DB 기반)
		// 금일 소비 전력량 계산
		// 시설별 소비 요금 계산
		// 시설별 소비 전력량 계산
		function getTodayPowerCost() {
			let date = moment().format("YYYYMMDD");
			let currentMonth = moment().month() + 1;
			let season = getSeason(currentMonth);

			console.log("========== 금일 소비 요금 계산 (DB) ==========");
			console.log("조회 날짜:", date, "계절:", season);

			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "getTodayPowerCost",
				dataType: "json",
				cache: false,
				data: JSON.stringify({ date: date, season: season }),
				success: function(res) {
					console.log("금일 소비 요금 응답:", res);

					if (!res || res.length === 0) {
						console.log("데이터 없음");
						$("#TOT_PRC").text("-");
						return;
					}

					let totalCost = Number(res.find(e=> e.FACILITY_ID == '합계')?.TOTAL_COST || 0);
					let totalUsage = Number(res.find(e=> e.FACILITY_ID == '합계')?.USAGE || 0);
					console.log("금일 소비 요금:", totalCost.toLocaleString(), "원");
					console.log("  TOTAL_USAGE: " + totalUsage + " MWh");
					console.log("==========================================");

					$("#TOT_PRC").text(totalCost.toLocaleString("ko-KR"));
					$("#TOT_USG").text(totalUsage.toFixed(2));
					res.forEach(item=>{
					    let procsId = item?.FACILITY_ID;
					    if (procsId != "" && procsId != "합계") {
					        let usgVal = Number(item.USAGE) || 0;
					        let prcVal = Number(item.TOTAL_COST) || 0;
					        $("#" + procsId + "_USG").text(usgVal.toFixed(2));
					        $("#" + procsId + "_PRC").text(Math.round(prcVal).toLocaleString("ko-KR"));
					    }
					})
				},
				error: function(xhr, status, err) {
					console.error("금일 소비 정보 조회 실패:", err);
					$("#TOT_PRC").text("-");
				}
			});
		}

		// 금일 소비 전력량 조회 (Tibero DB - DB에서 합산 처리)
		function getTodayPwrerUsage() {
			let date = moment().format("YYYYMMDD");

			console.log("========== 금일 소비 전력량 조회 (DB 합산) ==========");
			console.log("조회 날짜:", date);

			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "getTodayPowerUsageTotal",
				dataType: "json",
				cache: false,
				data: JSON.stringify({ date: date }),
				success: function(res) {
					console.log("금일 전력량 응답 데이터:", res);

					if (!res || res.length === 0) {
						console.log("데이터 없음");
						$("#TOT_USG").text("-");
						return;
					}

					// DB에서 합산된 값 직접 사용	
					let totalUsage = Number(res[0]?.TOTAL_USAGE) || 0;
					console.log("---------- DB 합산 결과 ----------");
					console.log("  TOTAL_USAGE: " + totalUsage + " MWh");
					if (totalUsage < 0) {
						console.log("  (음수이므로 0으로 처리)");
						totalUsage = 0;
					}
					console.log("==========================================");
					$("#TOT_USG").text(totalUsage.toFixed(2));
				},
				error: function(xhr, status, err) {
					console.error("금일 소비 전력량 조회 실패:", err);
					$("#TOT_USG").text("-");
				}
			});
		}


		// CO2 저감량 차트 초기화 (ECharts) - 전력량 단가 배경색 적용
		function initChart3(id) {
			let chart = echarts.init(document.getElementById(id));
			let option = {
				backgroundColor: "transparent",
				grid: {
					left: "3%",
					right: "4%",
					bottom: "3%",
					top: "10%",
					containLabel: true
				},
				tooltip: {
					trigger: "axis",
					axisPointer: {
						type: "cross",
						label: {
							show: true,
							backgroundColor: "#333"
						},
						lineStyle: { color: "#FFFFFF99" },
						crossStyle: { color: "#FFFFFF99" }
					},
					formatter: function(params) {
						let date = new Date(params[0].value[0]);
						let dateStr = moment(date).format("YYYY-MM-DD HH:mm");
						let val = params[0].value[1].toFixed(2);
						return dateStr + "<br/>CO₂ 저감량: " + val + " Ton";
					}
				},
				xAxis: {
					type: "time",
					axisPointer: {
						show: true,
						label: {
							show: true,
							formatter: function(params) {
								return moment(params.value).format("HH:mm");
							}
						}
					},
					axisLine: {
						show: true,
						lineStyle: { color: "#FFFFFF" }
					},
					axisTick: { show: true, lineStyle: { color: "#FFFFFF" } },
					axisLabel: {
						color: "#FFFFFF",
						formatter: function(value) {
							return moment(value).format("HH") + "시";
						}
					},
					splitLine: {
						show: true,
						lineStyle: { color: "#FFFFFF33" }
					}
				},
				yAxis: {
					type: "value",
					min: 0,
					axisPointer: {
						show: true,
						label: {
							show: true,
							formatter: function(params) {
								return params.value.toFixed(2) + " Ton";
							}
						}
					},
					axisLine: {
						show: true,
						lineStyle: { color: "#FFFFFF" }
					},
					axisTick: { show: true, lineStyle: { color: "#FFFFFF" } },
					axisLabel: { color: "#FFFFFF" },
					splitLine: {
						show: true,
						lineStyle: { color: "#FFFFFF33" }
					}
				},
				series: [{
					name: "CO₂ 저감량",
					type: "line",
					smooth: true,
					symbol: "circle",
					symbolSize: 6,
					// 시간대별 배경색 (전력량 단가 기준)
					markArea: {
						silent: true,
						data: getTimeMarkArea()
					},
					itemStyle: {
						color: "#4CAF50",
						borderColor: "#FFFFFF",
						borderWidth: 1
					},
					lineStyle: {
						color: "#4CAF50",
						width: 2
					},
					areaStyle: {
						color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
							{ offset: 0, color: "rgba(76, 175, 80, 0.5)" },
							{ offset: 1, color: "rgba(76, 175, 80, 0.1)" }
						])
					},
					data: []
				}]
			};
			chart.setOption(option);
			return chart;
		}

		// CO2 저감량 차트 데이터 로드 (DB 기반)
		function loadCO2ChartData(period) {
			period = period || "today";
			let date = moment().format("YYYYMMDD");

			console.log("========== CO2 차트 데이터 조회 (DB) ==========");
			console.log("기간:", period);

			// 기간별 API URL 및 파라미터 설정
			let apiUrl, apiParam;
			if (period === "today") {
				apiUrl = "getHourlySolarData";
				apiParam = { date: date, tagNm: "COM_SOLAR_CO2_RED" };
			} else if (period === "daily") {
				apiUrl = "getDailySolarData";
				apiParam = { date: date, tagNm: "COM_SOLAR_CO2_RED" };
			} else if (period === "monthly") {
				apiUrl = "getMonthlySolarData";
				apiParam = { date: date, tagNm: "COM_SOLAR_CO2_RED" };
			} else if (period === "yearly") {
				apiUrl = "getYearlySolarData";
				apiParam = { date: date, tagNm: "COM_SOLAR_CO2_RED" };
			} else {
				return;
			}

			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: apiUrl,
				dataType: "json",
				cache: false,
				data: JSON.stringify(apiParam),
				success: function(res) {
					console.log("CO2 차트 데이터:", res);

					if (!res || res.length === 0) {
						console.log("CO2 데이터 없음");
						if (dataObj.chart3) {
							dataObj.chart3.setOption({ series: [{ data: [] }] });
						}
						return;
					}

					let chartData = [];
					let xAxisOpt = {};

					if (period === "today") {
						// 금일: 시간별 데이터
						let startOfDay = moment().startOf('day').valueOf();
						chartData.push([startOfDay, 0]);
						res.forEach(item => {
							let hourKey = item.HOUR_KEY;
							let timeStr = hourKey.substring(0, 4) + "-" + hourKey.substring(4, 6) + "-" +
								hourKey.substring(6, 8) + " " + hourKey.substring(8, 10) + ":00";
							let timestamp = moment(timeStr, "YYYY-MM-DD HH:mm").valueOf();
							chartData.push([timestamp, Number(item.VAL) || 0]);
						});
						xAxisOpt = {
							type: "time",
							min: moment().startOf('day').valueOf(),
							max: moment().valueOf(),
							axisLabel: {
								color: "#FFFFFF",
								formatter: function(v) { return moment(v).format("HH") + "시"; }
							}
						};
					} else if (period === "daily") {
						// 일별: 최근 7일
						res.forEach(item => {
							let dateKey = item.DATE_KEY;
							let timeStr = dateKey.substring(0, 4) + "-" + dateKey.substring(4, 6) + "-" + dateKey.substring(6, 8);
							let timestamp = moment(timeStr, "YYYY-MM-DD").valueOf();
							chartData.push([timestamp, Number(item.VAL) || 0]);
						});
						xAxisOpt = {
							type: "time",
							min: null,
							max: null,
							axisLabel: {
								color: "#FFFFFF",
								formatter: function(v) { return moment(v).format("MM/DD"); }
							}
						};
					} else if (period === "monthly") {
						// 월별: 최근 12개월
						res.forEach(item => {
							let monthKey = item.MONTH_KEY;
							let timeStr = monthKey.substring(0, 4) + "-" + monthKey.substring(4, 6) + "-01";
							let timestamp = moment(timeStr, "YYYY-MM-DD").valueOf();
							chartData.push([timestamp, Number(item.VAL) || 0]);
						});
						xAxisOpt = {
							type: "time",
							min: null,
							max: null,
							axisLabel: {
								color: "#FFFFFF",
								formatter: function(v) { return moment(v).format("YY/MM"); }
							}
						};
					} else if (period === "yearly") {
						// 년도별: 최근 5년
						res.forEach(item => {
							let yearKey = item.YEAR_KEY;
							let timestamp = moment(yearKey + "-01-01", "YYYY-MM-DD").valueOf();
							chartData.push([timestamp, Number(item.VAL) || 0]);
						});
						xAxisOpt = {
							type: "time",
							min: null,
							max: null,
							axisLabel: {
								color: "#FFFFFF",
								formatter: function(v) { return moment(v).format("YYYY"); }
							}
						};
					}

					if (dataObj.chart3) {
						// 금일만 markArea(전력량 단가 배경색) 표시
						let markAreaOpt = (period === "today") ? { silent: true, data: getTimeMarkArea() } : { data: [] };
						dataObj.chart3.setOption({
							xAxis: xAxisOpt,
							series: [{ data: chartData, markArea: markAreaOpt }]
						});
					}
					console.log("==========================================");
				},
				error: function(xhr, status, err) {
					console.error("CO2 차트 데이터 로드 실패:", err);
				}
			});
		}

		// 시간대별 배경색 생성 함수 (em0104 전력량 단가 기준)
		function getTimeMarkArea() {
			let today = moment().format("YYYY-MM-DD");
			let currentMonth = moment().month() + 1;
			let season = getSeason(currentMonth);

			// 부하 구분별 색상 (1=경부하, 2=중간부하, 3=최대부하)
			const LOAD_COLORS = {
				1: "#83A6034D",  // 경부하 - 녹색
				2: "#F29F054D",  // 중간부하 - 주황색
				3: "#D952044D"   // 최대부하 - 빨간색
			};

			// LOAD_TYPE_BY_HOUR가 아직 로드되지 않았으면 빈 배열 반환
			if (!LOAD_TYPE_BY_HOUR || !LOAD_TYPE_BY_HOUR[season]) {
				return [];
			}

			let hourData = LOAD_TYPE_BY_HOUR[season];
			let markAreaData = [];
			let startHour = 0;
			let currentLv = hourData[0];

			for (let h = 1; h <= 24; h++) {
				let lv = (h < 24) ? hourData[h] : -1; // 24시는 종료 처리

				if (lv !== currentLv) {
					// 이전 구간 저장
					if (currentLv > 0) {
						let startTime = today + " " + String(startHour).padStart(2, "0") + ":00";
						let endTime = today + " " + String(h).padStart(2, "0") + ":00";
						if (h === 24) endTime = today + " 23:59";
						markAreaData.push([
							{ xAxis: startTime, itemStyle: { color: LOAD_COLORS[currentLv] || "#FFFFFF00" } },
							{ xAxis: endTime }
						]);
					}
					startHour = h;
					currentLv = lv;
				}
			}

			return markAreaData;
		}

		// 누적 전력량 차트 초기화 (ECharts)
		function initPwrerChart(id, title, unit) {
			let chart = echarts.init(document.getElementById(id));
			let option = {
				backgroundColor: "transparent",
				grid: {
					left: "3%",
					right: "4%",
					bottom: "3%",
					top: "10%",
					containLabel: true
				},
				tooltip: {
					trigger: "axis",
					axisPointer: {
						type: "cross",
						label: {
							show: true,
							backgroundColor: "#333"
						},
						lineStyle: {
							color: "#FFFFFF99"
						},
						crossStyle: {
							color: "#FFFFFF99"
						}
					},
					formatter: function(params) {
						let date = new Date(params[0].value[0]);
						let dateStr = moment(date).format("YYYY-MM-DD HH:mm");
						let val = params[0].value[1].toFixed(2);
						return dateStr + "<br/>" + title + ": " + val + " " + unit;
					}
				},
				xAxis: {
					type: "time",
					axisPointer: {
						show: true,
						label: {
							show: true,
							formatter: function(params) {
								return moment(params.value).format("HH:mm");
							}
						}
					},
					axisLine: {
						show: true,
						lineStyle: { color: "#FFFFFF" }
					},
					axisTick: { show: true, lineStyle: { color: "#FFFFFF" } },
					axisLabel: {
						color: "#FFFFFF",
						formatter: function(value) {
							return moment(value).format("HH") + "시";
						}
					},
					splitLine: {
						show: true,
						lineStyle: { color: "#FFFFFF33" }
					}
				},
				yAxis: {
					type: "value",
					min: 0,
					axisPointer: {
						show: true,
						label: {
							show: true,
							formatter: function(params) {
								return params.value.toFixed(2) + " " + unit;
							}
						}
					},
					axisLine: {
						show: true,
						lineStyle: { color: "#FFFFFF" }
					},
					axisTick: { show: true, lineStyle: { color: "#FFFFFF" } },
					axisLabel: { color: "#FFFFFF" },
					splitLine: {
						show: true,
						lineStyle: { color: "#FFFFFF33" }
					}
				},
				series: [{
					name: title,
					type: "line",
					smooth: true,
					symbol: "circle",
					symbolSize: 6,
					// 시간대별 배경색
					markArea: {
						silent: true,
						data: getTimeMarkArea()
					},
					itemStyle: {
						color: "#6CF",
						borderColor: "#FFFFFF",
						borderWidth: 1
					},
					lineStyle: {
						color: "#6CF",
						width: 2
					},
					data: []
				}]
			};
			chart.setOption(option);
			return chart;
		}

		// 소비 요금 차트 초기화 (ECharts)
		function initPriceChart(id, title, unit) {
			let chart = echarts.init(document.getElementById(id));
			let option = {
				backgroundColor: "transparent",
				grid: {
					left: "3%",
					right: "4%",
					bottom: "3%",
					top: "10%",
					containLabel: true
				},
				tooltip: {
					trigger: "axis",
					axisPointer: {
						type: "cross",
						label: {
							show: true,
							backgroundColor: "#333"
						},
						lineStyle: {
							color: "#FFFFFF99"
						},
						crossStyle: {
							color: "#FFFFFF99"
						}
					},
					formatter: function(params) {
						let date = new Date(params[0].value[0]);
						let dateStr = moment(date).format("YYYY-MM-DD HH:mm");
						let val = Math.round(params[0].value[1]).toLocaleString();
						return dateStr + "<br/>" + title + ": " + val + " " + unit;
					}
				},
				xAxis: {
					type: "time",
					axisPointer: {
						show: true,
						label: {
							show: true,
							formatter: function(params) {
								return moment(params.value).format("HH:mm");
							}
						}
					},
					axisLine: {
						show: true,
						lineStyle: { color: "#FFFFFF" }
					},
					axisTick: { show: true, lineStyle: { color: "#FFFFFF" } },
					axisLabel: {
						color: "#FFFFFF",
						formatter: function(value) {
							return moment(value).format("HH") + "시";
						}
					},
					splitLine: {
						show: true,
						lineStyle: { color: "#FFFFFF33" }
					}
				},
				yAxis: {
					type: "value",
					axisPointer: {
						show: true,
						label: {
							show: true,
							formatter: function(params) {
								return Math.round(params.value).toLocaleString() + " " + unit;
							}
						}
					},
					axisLine: {
						show: true,
						lineStyle: { color: "#FFFFFF" }
					},
					axisTick: { show: true, lineStyle: { color: "#FFFFFF" } },
					axisLabel: {
						color: "#FFFFFF",
						formatter: function(value) {
							return value.toLocaleString();
						}
					},
					splitLine: {
						show: true,
						lineStyle: { color: "#FFFFFF33" }
					}
				},
				series: [{
					name: title,
					type: "line",
					smooth: true,
					symbol: "none",
					// 시간대별 배경색
					markArea: {
						silent: true,
						data: getTimeMarkArea()
					},
					areaStyle: {
						color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
							{ offset: 0, color: "rgb(199, 113, 243)" },
							{ offset: 0.7, color: "rgb(76, 175, 254)" }
						])
					},
					lineStyle: {
						color: "rgb(199, 113, 243)",
						width: 1
					},
					data: []
				}]
			};
			chart.setOption(option);
			return chart;
		}

		// 전력 단가 정보 (원/kWh)
		const AVG_PRICE = {
			S: 124.1,  // 여름 평균
			F: 105.3,  // 봄가을 평균
			W: 124.2   // 겨울 평균
		};

		// 시설명 -> PROCS_ID 매핑
		const FACILITY_TO_PROCS = {
			'취수장': 'PROCS_1',
			'원수저류조': 'PROCS_2',
			'전전처리': 'PROCS_3',
			'전처리': 'PROCS_4',
			'RO': 'PROCS_5',
			'폐탈수처리': 'PROCS_7'
		};

		// 시설별 전력 데이터 조회 및 표시
		function getFacilityPowerData() {
			let date = moment().format("YYYYMMDD");
			let season = getSeason(moment().month() + 1);

			console.log("========== 시설별 전력 데이터 조회 (DB) ==========");
			console.log("조회 날짜:", date, "계절:", season);

			// 1. 시설별 실시간 전력 조회
			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "getFacilityRealTimePower",
				dataType: "json",
				cache: false,
				data: JSON.stringify({ date: date }),
				success: function(res) {
					console.log("시설별 실시간 전력:", res);
					if (res && res.length > 0) {
						res.forEach(item => {
							let procsId = FACILITY_TO_PROCS[item.FACILITY_ID];
							if (procsId) {
								let val = Number(item.REAL_TIME_POWER) || 0;
								$("#" + procsId + "_RT_PWRER").text(val.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ","));
							}
						});
					} else {
						console.log("시설별 실시간 전력 데이터 없음");
					}
				},
				error: function(xhr, status, err) {
					console.error("시설별 실시간 전력 조회 실패:", err);
				}
			});

			// 2. 시설별 금일 최대 전력 조회
			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "getFacilityMaxPower",
				dataType: "json",
				cache: false,
				data: JSON.stringify({ date: date }),
				success: function(res) {
					console.log("시설별 금일 최대 전력:", res);
					if (res && res.length > 0) {
						res.forEach(item => {
							let procsId = FACILITY_TO_PROCS[item.FACILITY_ID];
							if (procsId) {
								let val = Number(item.MAX_POWER) || 0;
								let hour = item.MAX_HOUR || "00";
								$("#" + procsId + "_MAX").text(val.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ","));
								$("#" + procsId + "_MAXTIME").text(hour);
							}
						});
					}
				},
				error: function(xhr, status, err) {
					console.error("시설별 금일 최대 전력 조회 실패:", err);
				}
			});

			/* 
			// 3. 시설별 소비 전력량 조회
			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "getFacilityPowerUsage",
				dataType: "json",
				cache: false,
				data: JSON.stringify({ date: date }),
				success: function(res) {
					console.log("시설별 소비 전력량:", res);
					if (res && res.length > 0) {
						res.forEach(item => {
							let procsId = FACILITY_TO_PROCS[item.FACILITY_ID];
							if (procsId) {
								let val = Number(item.POWER_USAGE_MWH) || 0;
								$("#" + procsId + "_USG").text(val.toFixed(2));
							}
						});
					}
				},
				error: function(xhr, status, err) {
					console.error("시설별 소비 전력량 조회 실패:", err);
				}
			});

			// 4. 시설별 소비 요금 조회
			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "getFacilityPowerCost",
				dataType: "json",
				cache: false,
				data: JSON.stringify({ date: date, season: season }),
				success: function(res) {
					console.log("시설별 소비 요금:", res);
					if (res && res.length > 0) {
						res.forEach(item => {
							let procsId = FACILITY_TO_PROCS[item.FACILITY_ID];
							if (procsId) {
								let val = Number(item.POWER_COST) || 0;
								$("#" + procsId + "_PRC").text(Math.round(val).toLocaleString("ko-KR"));
							}
						});
					}
				},
				error: function(xhr, status, err) {
					console.error("시설별 소비 요금 조회 실패:", err);
				}
			});
 */
			
			console.log("==========================================");
		}

		// 누적 전력량 차트 데이터 로드 (chart1) - DB 기반
		function loadPowerUsageChartData(period, type) {
			let date = moment().format("YYYYMMDD");
			let currentMonth = moment().month() + 1;
			let season = getSeason(currentMonth);

			console.log("========== 누적 전력량 차트 데이터 요청 ==========");
			console.log("기간:", period, "날짜:", date);

			// 기간별 API URL 설정
			/* 
			let apiUrl;
			if (period === "today") {
				apiUrl = "getChartHourlyPowerUsage";
			} else if (period === "daily") {
				apiUrl = "getChartDailyPowerUsage";
			} else if (period === "monthly") {
				apiUrl = "getChartMonthlyPowerUsage";
			} else if (period === "yearly") {
				apiUrl = "getChartYearlyPowerUsage";
			} else {
				return;
			}
 */
			let apiUrl;
			if (period === "today") {
				apiUrl = "getChartHourlyCost";
			} else if (period === "daily") {
				apiUrl = "getChartDailyCost";
			} else if (period === "monthly") {
				apiUrl = "getChartMonthlyCost";
			} else if (period === "yearly") {
				apiUrl = "getChartYearlyCost";
			} else {
				return;
			}

			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: apiUrl,
				dataType: "json",
				cache: false,
				data: JSON.stringify({ date: date, season: season, type: type }),
				success: function(res) {
					console.log("누적 전력량 차트 데이터:", res);

					if (!res || res.length === 0) {
						console.log("누적 전력량 데이터 없음");
						if (dataObj.chart1) {
							dataObj.chart1.setOption({ series: [{ data: [] }] });
						}
						return;
					}

					let chartData = [];
					let xAxisOpt = {};

					if (period === "today") {
						let startOfDay = moment().startOf('day').valueOf();
						chartData.push([startOfDay, 0]);
						res.forEach(item => {
							let hourKey = item.HOUR_KEY;
							let timeStr = hourKey.substring(0, 4) + "-" + hourKey.substring(4, 6) + "-" +
								hourKey.substring(6, 8) + " " + hourKey.substring(8, 10) + ":00";
							let timestamp = moment(timeStr, "YYYY-MM-DD HH:mm").valueOf();
							chartData.push([timestamp, Number(item.ACC_USAGE) || 0]);
						});
						xAxisOpt = {
							type: "time",
							min: moment().startOf('day').valueOf(),
							max: moment().valueOf(),
							axisLabel: {
								color: "#FFFFFF",
								formatter: function(v) { return moment(v).format("HH") + "시"; }
							}
						};
					} else if (period === "daily") {
						res.forEach(item => {
							let dateKey = item.DATE_KEY;
							let timeStr = dateKey.substring(0, 4) + "-" + dateKey.substring(4, 6) + "-" + dateKey.substring(6, 8);
							let timestamp = moment(timeStr, "YYYY-MM-DD").valueOf();
							chartData.push([timestamp, Number(item.DAILY_USAGE) || 0]);
						});
						xAxisOpt = {
							type: "time",
							min: null,
							max: null,
							axisLabel: {
								color: "#FFFFFF",
								formatter: function(v) { return moment(v).format("MM/DD"); }
							}
						};
					} else if (period === "monthly") {
						res.forEach(item => {
							let monthKey = item.MONTH_KEY;
							let timeStr = monthKey.substring(0, 4) + "-" + monthKey.substring(4, 6) + "-01";
							let timestamp = moment(timeStr, "YYYY-MM-DD").valueOf();
							chartData.push([timestamp, Number(item.MONTH_USAGE) || 0]);
						});
						xAxisOpt = {
							type: "time",
							min: null,
							max: null,
							axisLabel: {
								color: "#FFFFFF",
								formatter: function(v) { return moment(v).format("YY/MM"); }
							}
						};
					} else if (period === "yearly") {
						res.forEach(item => {
							let yearKey = item.YEAR_KEY;
							let timestamp = moment(yearKey + "-01-01", "YYYY-MM-DD").valueOf();
							chartData.push([timestamp, Number(item.YEAR_USAGE) || 0]);
						});
						xAxisOpt = {
							type: "time",
							min: null,
							max: null,
							axisLabel: {
								color: "#FFFFFF",
								formatter: function(v) { return moment(v).format("YYYY"); }
							}
						};
					}

					if (dataObj.chart1) {
						let markAreaOpt = (period === "today") ? { silent: true, data: getTimeMarkArea() } : { data: [] };
						dataObj.chart1.setOption({
							xAxis: xAxisOpt,
							series: [{ data: chartData, markArea: markAreaOpt }]
						});
					}
				},
				error: function(xhr, status, err) {
					console.error("누적 전력량 차트 데이터 조회 실패:", err);
				}
			});
		}

		// 소비 요금 차트 데이터 로드 (chart2) - DB 기반
		function loadCostChartData(period, type) {
			let date = moment().format("YYYYMMDD");
			let currentMonth = moment().month() + 1;
			let season = getSeason(currentMonth);

			console.log("========== 소비 요금 차트 데이터 요청 ==========");
			console.log("기간:", period, "날짜:", date, "계절:", season);

			// 기간별 API URL 설정
			let apiUrl;
			if (period === "today") {
				apiUrl = "getChartHourlyCost";
			} else if (period === "daily") {
				apiUrl = "getChartDailyCost";
			} else if (period === "monthly") {
				apiUrl = "getChartMonthlyCost";
			} else if (period === "yearly") {
				apiUrl = "getChartYearlyCost";
			} else {
				return;
			}

			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: apiUrl,
				dataType: "json",
				cache: false,
				data: JSON.stringify({ date: date, season: season, type: type }),
				success: function(res) {
					console.log("소비 요금 차트 데이터:", res);

					if (!res || res.length === 0) {
						console.log("소비 요금 데이터 없음");
						if (dataObj.chart2) {
							dataObj.chart2.setOption({ series: [{ data: [] }] });
						}
						return;
					}

					let chartData = [];
					let xAxisOpt = {};

					if (period === "today") {
						let startOfDay = moment().startOf('day').valueOf();
						chartData.push([startOfDay, 0]);
						res.forEach(item => {
							let hourKey = item.HOUR_KEY;
							let timeStr = hourKey.substring(0, 4) + "-" + hourKey.substring(4, 6) + "-" +
								hourKey.substring(6, 8) + " " + hourKey.substring(8, 10) + ":00";
							let timestamp = moment(timeStr, "YYYY-MM-DD HH:mm").valueOf();
							chartData.push([timestamp, Number(item.ACC_COST) || 0]);
						});
						xAxisOpt = {
							type: "time",
							min: moment().startOf('day').valueOf(),
							max: moment().valueOf(),
							axisLabel: {
								color: "#FFFFFF",
								formatter: function(v) { return moment(v).format("HH") + "시"; }
							}
						};
					} else if (period === "daily") {
						res.forEach(item => {
							let dateKey = item.DATE_KEY;
							let timeStr = dateKey.substring(0, 4) + "-" + dateKey.substring(4, 6) + "-" + dateKey.substring(6, 8);
							let timestamp = moment(timeStr, "YYYY-MM-DD").valueOf();
							chartData.push([timestamp, Number(item.DAILY_COST) || 0]);
						});
						xAxisOpt = {
							type: "time",
							min: null,
							max: null,
							axisLabel: {
								color: "#FFFFFF",
								formatter: function(v) { return moment(v).format("MM/DD"); }
							}
						};
					} else if (period === "monthly") {
						res.forEach(item => {
							let monthKey = item.MONTH_KEY;
							let timeStr = monthKey.substring(0, 4) + "-" + monthKey.substring(4, 6) + "-01";
							let timestamp = moment(timeStr, "YYYY-MM-DD").valueOf();
							chartData.push([timestamp, Number(item.MONTH_COST) || 0]);
						});
						xAxisOpt = {
							type: "time",
							min: null,
							max: null,
							axisLabel: {
								color: "#FFFFFF",
								formatter: function(v) { return moment(v).format("YY/MM"); }
							}
						};
					} else if (period === "yearly") {
						res.forEach(item => {
							let yearKey = item.YEAR_KEY;
							let timestamp = moment(yearKey + "-01-01", "YYYY-MM-DD").valueOf();
							chartData.push([timestamp, Number(item.YEAR_COST) || 0]);
						});
						xAxisOpt = {
							type: "time",
							min: null,
							max: null,
							axisLabel: {
								color: "#FFFFFF",
								formatter: function(v) { return moment(v).format("YYYY"); }
							}
						};
					}

					if (dataObj.chart2) {
						let markAreaOpt = (period === "today") ? { silent: true, data: getTimeMarkArea() } : { data: [] };
						dataObj.chart2.setOption({
							xAxis: xAxisOpt,
							series: [{ data: chartData, markArea: markAreaOpt }]
						});
					}
				},
				error: function(xhr, status, err) {
					console.error("소비 요금 차트 데이터 조회 실패:", err);
				}
			});
		}
	</script>
</body>
</html>