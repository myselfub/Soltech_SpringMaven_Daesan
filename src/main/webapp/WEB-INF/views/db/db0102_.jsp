<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>운영현황</title>

<script src="resources/js/highcharts/highcharts.js"></script>
<!-- <script src="resources/js/highcharts/modules/data.js"></script> -->
<script src="resources/js/highcharts/modules/exporting.js"></script>
<script src="resources/js/highcharts/modules/accessibility.js"></script>

<style>
	.RigthBox {background: #162B42;}
	.dataBox {
		position: absolute;
		top: 0;
		left: 0;
		z-index: 1;
	}
	
	#gridBox1 table tr {border-bottom: 1px solid #4C5871;}
	#gridBox1 table tr td {color:#EAEAEC; height: 40px; }
	
	.scrollBox::-webkit-scrollbar{background: #3e4961; width: 12px;}
	.scrollBox::-webkit-scrollbar-thumb {
		width: 8px;
		background: #7A87A3;
	}

	.scrollBox::-webkit-scrollbar-button {
		height: 20px;
		content: "a"
	}
</style>
</head>
<body>
	<canvas id="Graphics1"></canvas>
	<div class="dataBox" id="chartBox1" style="top: 350px; left: 160px; width: 785px; height: 380px;">
		<div id="chart1" style="width: 100%; height: 100%;"></div>
	</div>
	<div class="dataBox" id="chartBox2" style="top: 280px; left: 985px; width: 465px; height: 440px;">
		<div id="chart2" style="width: 100%; height: 50%;"></div>
		<div id="chart3" style="width: 100%; height: 50%;"></div>
	</div>
	<div class="dataBox" id="gridBox1" style="top: 810px; left: 1500px; width: 365px; height: 215px;">
		<div class="scrollBox" style="width: auto; height: 100%; overflow-y: scroll; padding-right: 10px;">
			<table>
				<colgroup>
					<col style="width: 40px;"/>
					<col style="width: 110px;"/>
					<col/>
				</colgroup>
				<tr><td>01</td><td>경보발생</td><td>경보 발생 상세 내용</td>	</tr>
				<tr><td>02</td><td>경보발생</td><td>경보 발생 상세 내용</td>	</tr>
				<tr><td>03</td><td>경보발생</td><td>경보 발생 상세 내용</td>	</tr>
				<tr><td>04</td><td>경보발생</td><td>경보 발생 상세 내용</td>	</tr>
				<tr><td>05</td><td>경보발생</td><td>경보 발생 상세 내용</td>	</tr>
				<tr><td>06</td><td>경보발생</td><td>경보 발생 상세 내용</td>	</tr>
				<tr><td>07</td><td>경보발생</td><td>경보 발생 상세 내용</td>	</tr>
				<tr><td>08</td><td>경보발생</td><td>경보 발생 상세 내용</td>	</tr>
				<tr><td>09</td><td>경보발생</td><td>경보 발생 상세 내용</td>	</tr>
				<tr><td>10</td><td>경보발생</td><td>경보 발생 상세 내용</td>	</tr>
			</table>
		</div>
	</div>
	<script>
		var canvas_id = "#Graphics1";
		let chartBoxArr = [
			{boxId: "chartBox1", width: 785, height: 380, left: 50, top: 360, chart: [null]},
			{boxId: "chartBox2", width: 465, height: 440, left: 875, top: 300, chart: [null, null]},
			{boxId: "gridBox1", width: 365, height: 215, left: 1390, top: 820}
		];
		// 윈도우 사이즈 변경 시 박스들 위치 조정하는 함수
		window.addEventListener("resize", function() {
			let canvasWidth = 1810; ///$(".RigthBox").width();
			let canvasHeight = 1080; //$(".leftBox").height();

			if (window.innerHeight >= window.screen.availHeight) {
				const agent = window.navigator.userAgent.toLowerCase();
				if (agent.indexOf("edge") > -1 || agent.indexOf("edg/") > -1) {
					$(canvas_id).width(window.innerWidth);
				} else {
					$(canvas_id).width(window.innerWidth);
				}

				$(canvas_id).height(window.innerHeight);
				$(canvas_id).css("left", "0px");
				$(".leftBox").hide();
			} else {
				$(".leftBox").show();
				let left = 110;

				$(canvas_id).width(window.innerWidth - left);
				$(canvas_id).height(window.innerHeight);
				$(canvas_id).css("left", "110px");
			}
			let zoomRatioX = $(canvas_id).width() / canvasWidth;
			let zoomRatioY = $(canvas_id).height() / canvasHeight;

			let ratio = { // 요소들 화면 배율에 따라 위치 조정하기 위한
					left: $(canvas_id).width() / canvasWidth,
					top: $(canvas_id).height() / canvasHeight,
					zoom: Math.min(zoomRatioX, zoomRatioY),
					zoomX: zoomRatioX,
					zoomY: zoomRatioY
			};
			for (let idx in chartBoxArr) {
				let obj = chartBoxArr[idx];
				$("#"+obj.boxId).css("width", obj.width * ratio.zoomX);
				$("#"+obj.boxId).css("height", obj.height * ratio.zoom);
				$("#"+obj.boxId).css("left", obj.left * ratio.left + ($(".leftBox").is(":visible") ? 110 : 0));
				$("#"+obj.boxId).css("top", obj.top * ratio.top);
			}
		});

		// 처음 로드 다되면 
		window.onload = function() {
			$(canvas_id).bizRender( {
				//width : 1810,
				//height : 1080,
				//left: 110,
				layoutPath : "../../resources/layout/",
				imagesPath : "../../resources/images/biznexus/",
				urlPrefix : "",
				fileName : "db0102_2",
				interval : 1000,
				tagList: [],
				onTimeChanged: function(date){
				},
				onValueChanged: function(tagValues){
					console.log(tagValues);
					//BTN_A
				},
				onItemClick: function(e){
					console.log(e)
				},
			});
			CreateContextmenu(canvas_id);
			Highcharts.setOptions({
				lang: {
					thousandsSep: ","
				}
			});
			initChart1();
			initChart2();
			initChart3();
		};

		function initChart1() {
			chartBoxArr[0].chart[0] = Highcharts.chart("chart1", {
				chart: {
					backgroundColor: "#FFFFFF00"
				},
				credits: {enabled: false},
				exporting: {enabled: false},
				title: {text: ""},
				subtitle: {text: ""},
				yAxis: {
					title: {text: ""},
					labels: {
						style: {
							color: "#FFFFFF"
						}
					},
					lineColor: "#FFFFFF",
				},
				xAxis: {
					labels: {
						style: {
							color: "#FFFFFF"
						}
					},
					lineColor: "#FFFFFF",
				},
				legend: {enabled: false},
				plotOptions: {
					series: {
						label: {
							connectorAllowed: false
						},
						pointStart: 2010
					}
				},

				series: [{
					name: "Installation & Developers",
					data: [
						43934, 48656, 65165, 81827, 112143, 142383,
						171533, 165174, 155157, 161454, 154610, 168960, 171558
					],
					color: "#3AE7FF"
				}, {
					name: "Manufacturing",
					data: [
						24916, 37941, 29742, 29851, 32490, 30282,
						38121, 36885, 33726, 34243, 31050, 33099, 33473
					],
					color: "#FF5BC7"
				}],
				responsive: {
					rules: [{
						condition: {
							maxWidth: 500
						},
						chartOptions: {
							legend: {enabled: false}
						}
					}]
				}
			});
		};

		function initChart2() {
			chartBoxArr[1].chart[0] = Highcharts.chart("chart2", {
				chart: {
					type: "pie",
					backgroundColor: "#FFFFFF00",
				},
				credits: {enabled: false},
				accessibility: {
					point: {
						valueSuffix: "%"
					}
				},
				exporting: {enabled: false},
				title: {text: ""},
				subtitle: {text: ""},
				legend: {
					layout: "vertical",
					align: "right",
					verticalAlign: "middle",
					symbolWidth: 20, // 심볼 너비 설정
					symbolRadius: 0,
					itemStyle: {
						color: "#FFFFFF"
					}
				},
				plotOptions: {
					series: {
						allowPointSelect: false,
						cursor: "pointer",
						dataLabels: [{
							enabled: true,
							distance: -15,
							format: "{point.y:.0f}",
							style: {
								fontSize: "0.9em"
							}
						}],
					}
				},
				series: [{
					name: "Registrations",
					colorByPoint: true,
					innerSize: "65%",
					showInLegend: true,
					borderRadius: 0,
					data: [{
						name: "생산수 유입 염소이온농도",
						y: 23.9,
						borderColor: "#FF33A1",
						color: "#FF33A1"
					}, {
						name: "생산수 유입 전기전도도",
						y: 12.6,
						borderColor: "#FFD747",
						color: "#FFD747"
					}, {
						name: "생산수 유입 염분도계",
						y: 37.0,
						borderColor: "#47F979",
						color: "#47F979"
					}, {
						name: "생산수 유입 수소이온농도",
						y: 26.4,
						borderColor: "#47C5FF",
						color: "#47C5FF"
					}, {
						name: "생산수 수입 기타",
						y: 26.4,
						borderColor: "#B016FE",
						color: "#B016FE"
					}]
				}]
			});
		};

		function initChart3() {
			chartBoxArr[1].chart[1] = Highcharts.chart("chart3", {
				chart: {
					type: "pie",
					backgroundColor: "#FFFFFF00",
				},
				credits: {enabled: false},
				accessibility: {
					point: {
						valueSuffix: "%"
					}
				},
				exporting: {enabled: false},
				title: {text: ""},
				subtitle: {text: ""},
				legend: {
					layout: "vertical",
					align: "right",
					verticalAlign: "middle",
					symbolWidth: 20, // 심볼 너비 설정
					symbolRadius: 0,
					itemStyle: {
						color: "#FFFFFF"
					}
				},
				plotOptions: {
					series: {
						allowPointSelect: false,
						cursor: "pointer",
						dataLabels: [{
							enabled: true,
							distance: -15,
							format: "{point.y:.0f}",
							style: {
								fontSize: "0.9em"
							},
							shadow: false
						}],
					}
				},
				series: [{
					name: "Registrations",
					colorByPoint: true,
					innerSize: "65%",
					showInLegend: true,
					borderRadius: 0,
					data: [{
						name: "생산수 유입 염소이온농도",
						y: 23.9,
						borderColor: "#FF33A1",
						color: "#FF33A1"
					}, {
						name: "생산수 유입 전기전도도",
						y: 12.6,
						borderColor: "#FFD747",
						color: "#FFD747"
					}, {
						name: "생산수 유입 염분도계",
						y: 37.0,
						borderColor: "#47F979",
						color: "#47F979"
					}, {
						name: "생산수 유입 수소이온농도",
						y: 26.4,
						borderColor: "#47C5FF",
						color: "#47C5FF"
					}, {
						name: "생산수 수입 기타",
						y: 26.4,
						borderColor: "#B016FE",
						color: "#B016FE"
					}]
				}]
			});
		};
	</script>
</body>
</html>