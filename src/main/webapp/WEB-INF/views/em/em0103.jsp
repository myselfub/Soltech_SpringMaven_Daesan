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
<title>에너지관리 - 전력 통계 현황</title>
<script src="resources/js/highcharts/highcharts.js"></script>
<!-- <script src="resources/js/highcharts/modules/data.js"></script> -->
<script src="resources/js/highcharts/modules/exporting.js"></script>
<script src="resources/js/highcharts/modules/accessibility.js"></script>
<style>
.em-procs-menu {
	display: flex;
	justify-content: center;
	position: relative;
	top: -1rem;
	height: 56px;
	background: #f5f5f5;
	column-gap: 0.3rem;
}

.em-procs-menu .navi {
	display: flex;
	width: fit-content;
	flex-direction: column;
	justify-content: center;
}

.em-procs-menu .navi-path {
	width: 142px;
	height: 44px;
	padding: 0.3rem;
	text-align: center;
	display: flex;
	justify-content: center;
	flex-direction: column;
	font-family: 'Pretendard-SemiBold';
	color: #313b4c;
}

.em-procs-menu .navi .navi-path:hover, .em-procs-menu .navi .navi-path.active
	{
	background: #293347;
	color: #fff;
	border-radius: 4px;
}
</style>
</head>
<body>
	<div class="em-procs-menu">
		<div class="navi">
			<a class="navi-path" href="em0105">전체</a>
		</div>
		<div class="navi">
			<a class="navi-path" href="em0103?procs=contents1" id="contents1">취수장</a>
		</div>
		<div class="navi">
			<a class="navi-path" href="em0103?procs=contents2" id="contents2">원수저류조</a>
		</div>
		<div class="navi">
			<a class="navi-path" href="em0103?procs=contents3" id="contents3">전전처리(DAF)</a>
		</div>
		<div class="navi">
			<a class="navi-path" href="em0103?procs=contents4" id="contents4">전처리(DMGF)</a>
		</div>
		<div class="navi">
			<a class="navi-path" href="em0103?procs=contents5" id="contents5">RO(SW,BW)</a>
		</div>
		<div class="navi">
			<a class="navi-path" href="em0103?procs=contents6" id="contents6">생산수/공급</a>
		</div>
		<div class="navi">
			<a class="navi-path" href="em0103?procs=contents7" id="contents7">폐.탈수처리</a>
		</div>
		<div class="navi">
			<a class="navi-path" href="em0103?procs=contents8" id="contents8">농축수/방류</a>
		</div>
		<div class="navi">
			<a class="navi-path" href="em0103?procs=contents9" id="contents9">관로(취송수)</a>
		</div>
	</div>
	<div id="main" class="main-pss main-contents-grid1"
		style="height: 95%;"></div>
	<script>
		$(document).ready(function() {
			let urlSearch = new URLSearchParams(location.search);
			let contents_id = urlSearch.get("procs");
			$("#"+contents_id).addClass("active");
			$("#main").load("resources/html/em0103/"+contents_id+".html?time="+(new Date()).format("yyyymmddhhmmss"), function() {
				init();
			});
		});

		let dataObj = {
			isEvent: false,
			eventTime: 10,
			timeOutTime: 5,
			timeOutId: null
		};

		function init() {
			// 조회기간 초기설정
			let start = new Date();
			setDateTime($("#stdDate"), undefined, start);
			search();

			// 실시간 TAG 값 조회
			fetchTagValues();
			// 주기적 갱신 (5초)
			setInterval(function() {
				fetchTagValues();
				getProcsPowerStatus();  // 전력 현황도 5초마다 갱신
			}, 5000);
		};

		// Historian에서 TAG 값 조회
		function fetchTagValues() {
			// data-tag 속성이 있는 모든 요소 찾기
			let tagElements = document.querySelectorAll("[data-tag]");
			let tagList = [];

			tagElements.forEach(emt => {
				let tag = emt.getAttribute("data-tag");
				if (!tag) return;
				// 쉼표 구분 태그를 개별 분리하여 수집
				tag.split(",").forEach(t => {
					t = t.trim();
					if (t && !tagList.includes(t)) {
						tagList.push(t);
					}
				});
			});

			if (tagList.length === 0) return;

			ajaxData(tagList).then((res) => {
				if (res && res.param) {
					// 태그명 → 값 맵 구성
					let valMap = {};
					res.param.forEach(item => {
						valMap[item.name] = item.val;
					});

					tagElements.forEach(emt => {
						let tag = emt.getAttribute("data-tag");
						if (!tag) return;
						let tagName = emt.tagName.toLowerCase();
						if (tagName !== "span" && tagName !== "div") return;

						let tags = tag.split(",").map(t => t.trim());
						let mode = emt.getAttribute("data-tag-mode");

						// 복합 태그 (data-tag-mode 지정)
						if (tags.length > 1 && mode) {
							if (mode === "sum") {
								let sum = 0;
								tags.forEach(t => { sum += Number(valMap[t] || 0); });
								emt.textContent = Math.round(sum);
							} else if (mode === "list") {
								let vals = tags.map(t => {
									let v = valMap[t];
									if (v !== null && v !== undefined) {
										let n = Number(v);
										return !isNaN(n) ? n.toFixed(2) : v;
									}
									return "-";
								});
								emt.textContent = vals.join(" , ");
							}
							return;
						}

						// 단일 태그 (기존 로직)
						let val = valMap[tags[0]];
						let imgEmt = emt.querySelector("img");
						if (imgEmt) {
							let onOffData = Number(val) == 0 ? false : true;
							if (onOffData) {
								imgEmt.classList.add("on-img");
								imgEmt.classList.remove("off-img");
							} else {
								imgEmt.classList.remove("on-img");
								imgEmt.classList.add("off-img");
							}
						} else {
							if (val !== null && val !== undefined) {
								let numVal = Number(val);
								if (!isNaN(numVal)) {
									emt.textContent = numVal.toFixed(2);
								} else {
									emt.textContent = val;
								}
							} else {
								emt.textContent = "-";
							}
						}
					});
				}
			});
		}

		// Historian API 호출
		function ajaxData(tagList) {
			return new Promise((resolve, reject) => {
				let obj = {
					"cmd": "reqValues",
					"timeout": 15 * 1000,
					"dest": "historian",
					"param": {
						"tagList": tagList
					}
				};

				$.ajax({
					type: "POST",
					contentType: "application/json; charset=UTF-8",
					url: "/reqHistorian",
					dataType: "json",
					cache: false,
					data: JSON.stringify(obj),
					success: function(res) {
						resolve(res);
					},
					error: function(e) {
						console.error("Historian 조회 실패:", e);
						reject(e);
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

		// 공정별 전력 현황 조회 (DB 기반)
		function getProcsPowerStatus() {
			let urlSearch = new URLSearchParams(location.search);
			let procs = urlSearch.get("procs");
			if (!procs) return;

			// 공정 ID 매핑 (contents1 -> PROCS_1)
			let procsId = procs.replace("contents", "PROCS_");
			let date = moment().format("YYYYMMDD");
			let season = getSeason(moment().month() + 1);

			console.log("========== 공정별 전력 현황 조회 (DB) ==========");
			console.log("공정:", procsId, "날짜:", date, "계절:", season);

			// 1. 실시간 전력 조회 (DB)
			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "getProcsRealTimePower",
				dataType: "json",
				cache: false,
				data: JSON.stringify({ procsId: procsId, date: date }),
				success: function(res) {
					console.log("실시간 전력:", res);
					if (res && res.length > 0) {
						let val = Number(res[0].REAL_TIME_POWER) || 0;
						$("#RT_POWER").text(val.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ","));
					} else {
						$("#RT_POWER").text("-");
					}
				},
				error: function(xhr, status, err) {
					console.error("실시간 전력 조회 실패:", err);
					$("#RT_POWER").text("-");
				}
			});

			// 2. 금일 최대 전력 조회 (DB)
			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "getProcsMaxPower",
				dataType: "json",
				cache: false,
				data: JSON.stringify({ procsId: procsId, date: date }),
				success: function(res) {
					console.log("금일 최대 전력:", res);
					if (res && res.length > 0) {
						let val = Number(res[0].MAX_POWER) || 0;
						let hour = res[0].MAX_HOUR || "-";
						$("#MAX_POWER").text(val.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ","));
						$("#maxTime").text(hour + "시");
					} else {
						$("#MAX_POWER").text("-");
						$("#maxTime").text("-");
					}
				},
				error: function(xhr, status, err) {
					console.error("금일 최대 전력 조회 실패:", err);
					$("#MAX_POWER").text("-");
					$("#maxTime").text("-");
				}
			});

			// 3. 소비 전력량 조회 (DB)
			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "getProcsPowerUsage",
				dataType: "json",
				cache: false,
				data: JSON.stringify({ procsId: procsId, date: date }),
				success: function(res) {
					console.log("소비 전력량:", res);
					if (res && res.length > 0) {
						let val = Number(res[0].POWER_USAGE_MWH) || 0;
						$("#USG_POWER").text(val.toFixed(2));
					} else {
						$("#USG_POWER").text("-");
					}
				},
				error: function(xhr, status, err) {
					console.error("소비 전력량 조회 실패:", err);
					$("#USG_POWER").text("-");
				}
			});

			// 4. 소비 요금 조회 (DB)
			/*
			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "getProcsPowerCost",
				dataType: "json",
				cache: false,
				data: JSON.stringify({ procsId: procsId, date: date, season: season }),
				success: function(res) {
					console.log("소비 요금:", res);
					if (res && res.length > 0) {
						let val = Number(res[0].POWER_COST) || 0;
						$("#PRC_POWER").text(Math.round(val).toLocaleString("ko-KR"));
					} else {
						$("#PRC_POWER").text("-");
					}
				},
				error: function(xhr, status, err) {
					console.error("소비 요금 조회 실패:", err);
					$("#PRC_POWER").text("-");
				}
			});
			*/
			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "getTodayPowerCost",
				dataType: "json",
				cache: false,
				data: JSON.stringify({ procsId: procsId, date: date, season: season }),
				success: function(res) {
					console.log("소비 요금:", res);
					if (res && res.length > 0) {
						const item = res.find(e=>e.FACILITY_ID == procsId);
						if(item){
							let prcVal = Number(item.TOTAL_COST) || 0;
							$("#PRC_POWER").text(Math.round(prcVal).toLocaleString("ko-KR"));
							
							let usgVal = Number(item.USAGE) || 0;
							$("#USG_POWER").text(usgVal.toFixed(2));
						}
					} else {
						$("#PRC_POWER").text("-");
					}
				},
				error: function(xhr, status, err) {
					console.error("소비 요금 조회 실패:", err);
					$("#PRC_POWER").text("-");
				}
			});

			console.log("==========================================");
		}

		function search() {
			initChart();
			getProcsPowerStatus();
		};

		var gChart = null;
		function initChart(chng_type) {
			if (chng_type == "chart_type") {
				// 데이터 종류가 변경되면 차트 종류도 달라져서 새로 그림
				gChart.destroy();
				gChart = null;
			}

			let type = $("#sel_chart_type option:selected").val();
			if (gChart != null) {
				getChartStatisticsData(type);
			} else {
				Highcharts.setOptions({
					lang: {
						thousandsSep: ","
					}
				});

				if (type == "ACC") {
					gChart = Highcharts.chart("container", {
						chart: {
							type: "column",
							animation: false
						},
						title: {
							text: "",
							align: "left"
						},
						subtitle: {
							text: "",
							align: "left"
						},
						xAxis: {
							categories: [],
							crosshair: true,
							tickInterval: 0,
							labels : {
								rotation : 0
							}
						},
						yAxis: {
							min: 0,
							title: {
								text: ""
							}
						},
						tooltip: {
							valueDecimals: 2,
							valueSuffix: " KW",
							shared: true
						},
						plotOptions: {
							column: {
								pointPadding: 0.2,
								borderWidth: 0
							},
							series: {
								centerInCategory: true,
								animation: false
							}
						},
						series: []
					});
				} else if (type == "MAX") {
					gChart = Highcharts.chart("container", {
						chart: {
							animation: false
						},
						title: {
							text: "",
							align: "left"
						},
						subtitle: {
							text: "",
							align: "left"
						},
						yAxis: {
							title: {
								text: ""
							}
						},
						xAxis: {
							categories: [],
							crosshair: true,
							accessibility: {
								description: "Date"
							}
						},
						plotOptions: {
							series: {
								centerInCategory: true,
								animation: false,
								marker: {
									radius: 0 // 전체 마커 크기 조절
								}
							}
						},
						series: [],
						tooltip: {
							valueDecimals: 2,
							valueSuffix: " KW",
							shared: true
						},
						responsive: {
							rules: [{
								condition: {
									maxWidth: 500
								},
								chartOptions: {
									legend: {
										layout: "horizontal",
										align: "center",
										verticalAlign: "bottom"
									}
								}
							}]
						}

					});
				} else if (type == "USG") {
					gChart = Highcharts.chart("container", {
						chart: {
							type: "column",
							animation: false
						},
						title: {
							text: "",
							align: "left"
						},
						subtitle: {
							text: "",
							align: "left"
						},
						xAxis: {
							categories: [],
							crosshair: true,
							tickInterval: 0,
							labels : {
								rotation : 0
							}
						},
						yAxis: {
							min: 0,
							title: {
								text: ""
							}
						},
						tooltip: {
							valueDecimals: 2,
							valueSuffix: " KW",
							shared: true,
							formatter: function() {
								let points = this.points;
								let res = `<span style="font-size: 12px;">\${this.x}</span><br/>`;

								for (let point of points) {
									let procs_nm = point.series.name;
									let usg = (point.y).toLocaleString(undefined, { minimumFractionDigits: 2});
									let prc = (point.series.userOptions.data_obj[point.x].prc).toLocaleString(undefined, { minimumFractionDigits: 2});
									res += `<span style="color: \${point.color}; margin-bottom: 2px;">● </span>
 											<span style="font-size: 12px;">\${procs_nm}:</span>
 											<b> \${usg} KW </b>
 											<span style="font-size: 12px;">(사용 금액: \${prc} 원)</span>
											<br/>`;
								}

								return res;
							}
						},
						plotOptions: {
							column: {
								pointPadding: 0.2,
								borderWidth: 0
							},
							series: {
								centerInCategory: true,
								animation: false
							}
						},
						series: []
					});
				}
				getChartStatisticsData(type);
			}
		};

		function getChartStatisticsData(type) {
			if (type == "USG") {
				let range = $("#sel_chart_range option:selected").val();
				let to = $("#stdDate").val();
				let from = moment(to).subtract(Number(range), "month").format("YYYY-MM-DD");
				let obj = {
					from: moment(from).format("YYYYMMDD"),
					to: moment(to).format("YYYYMMDD"),
					type: $("#sel_chart_type option:selected").val()
				};

				$.ajax ({
					type: "POST",
					contentType: "application/json; charset=utf-8",
					cache : false,
					url: "getChartPwereUsgPrc",
					dataType: "json",
					data: JSON.stringify(obj),
					success: function(data) {
						makeChartData_Usg(from, to, data);
					}
				});
			} else {
				let obj = {
					date: $("#stdDate").val(),
					range: $("#sel_chart_range option:selected").val(),
					type: $("#sel_chart_type option:selected").val()
				};

				$.ajax ({
					type: "POST",
					contentType: "application/json; charset=utf-8",
					cache : false,
					url: "getChartStatisticsData",
					dataType: "json",
					data: JSON.stringify(obj),
					success: function(data) {
						makeChartData(data)
					}
				});
			}
		};

		async function makeChartData_Usg(from, to, data) {
			let procInfo = await getProcInfoList(undefined, "data");
			let category = new Array();
			let chartDataObj = new Object();

			// 날짜 안비게 템플릿 만들기
			let s_dt = moment(from).format("YYYY-MM-DD");
			let e_dt = moment(to).format("YYYY-MM-DD");

			let data_template = new Object();
			while (s_dt <= e_dt) {
				category.push(s_dt);

				data_template[s_dt] = {
					DATA_DT: s_dt,
					YYYY: moment(s_dt).format("YYYY"),
					MM: moment(s_dt).format("MM"),
					DD: moment(s_dt).format("DD"),
					usg: null,
					prc: null
				};
				s_dt = moment(s_dt).add(1, "day").format("YYYY-MM-DD");
			}

			// 공정별 템플릿 만들기
			for (let proc of procInfo) {
				chartDataObj[proc.PROCS_ID] = {
					proc_cd: proc.PROCS_ID,
					name: proc.PROCS_NM,
					data: new Array(),
					data_obj : JSON.parse(JSON.stringify(data_template)),
					visible: (proc.PROCS_SN == 6 ? false : true) // 주요 공정만 기본 보이기 설정
				};
			}

			// 조회한 데이터 셋팅하기
			for (let d of data) {
				chartDataObj[d.PROCS_ID]["data_obj"][d.DATA_DT].usg = d.USG;
				chartDataObj[d.PROCS_ID]["data_obj"][d.DATA_DT].prc = d.PRC;
			}

			// 배열로 만들기
			for (let proc_obj of procInfo) {
				let data_obj = chartDataObj[proc_obj.PROCS_ID].data_obj;
				for (let date in data_obj) {
					chartDataObj[proc_obj.PROCS_ID].data.push(data_obj[date].usg);
				}
			}
			redrawChart(chartDataObj, category);
		};

		async function makeChartData(data) {
			let procInfo = await getProcInfoList(undefined, "data");

			// object 형태로 변환 (카테고리랑 시리즈 만들기 편하려고)
			let category = new Array();
			let chartDataObj = new Object();
			for (let proc of procInfo) {
				let obj = {
					proc_cd: proc.PROCS_ID,
					name: proc.PROCS_NM,
					data: new Array(),
					visible: true // 주요 공정만 기본 보이기 설정
				};
				chartDataObj[proc.PROCS_ID] = obj;
			}

			// 카테고리랑 시리즈 만들기
			let tmpData = new Object();
			for (let obj of data) {
				if (!!!tmpData[obj.DATA_DT]) {
					tmpData[obj.DATA_DT] = new Object();
				}
				tmpData[obj.DATA_DT][obj.PROCS_ID] = (obj.LAST_VALUE || null);
			}

			for (let date in tmpData) {
				category.push(date.replace(/(\d{4})(\d{2})(\d{2})/g, "$1-$2-$3"));
				let values = tmpData[date];
				for (let procs_id in values) {
					let val = values[procs_id];
					if (chartDataObj[procs_id]) {
						chartDataObj[procs_id].data.push(val);
					}
				}
			}

			redrawChart(chartDataObj, category);
		};

		function redrawChart(chartDataObj, category) {
			let type = $("#sel_chart_type option:selected").val();
			let range = $("#sel_chart_range option:selected").val();
			// 기존 차트 초기화
			let arr_visible = new Object();
			for (let i = gChart.series.length - 1; i >= 0 ; i--) {
				// 시리즈 visible 상태 유지하려고
				let proc_cd = gChart.series[i].userOptions.proc_cd;
				let visible = gChart.series[i].visible;
				arr_visible[proc_cd] = visible;

				gChart.series[i].remove();
			}
			gChart.xAxis[0].categories = [];

			// 차트에 새로운 데이터 set 하기
			for (let proc in chartDataObj) {
				if (arr_visible[proc] != undefined) chartDataObj[proc].visible = arr_visible[proc];
				gChart.addSeries(chartDataObj[proc]);
			}

			gChart.xAxis[0].setCategories(category);
			gChart.xAxis[0].options.tickInterval = Number(range) * 2; // category 너무 많아서 깨져가지고
			gChart.xAxis[0].isDirty = true;
			gChart.redraw();
		};
	</script>
</body>
</html>
