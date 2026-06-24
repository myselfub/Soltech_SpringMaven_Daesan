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
<script src="resources/js/highcharts/highcharts-more.js"></script>
<!-- <script src="resources/js/highcharts/modules/data.js"></script> -->
<script src="resources/js/highcharts/modules/exporting.js"></script>
<script src="resources/js/highcharts/modules/accessibility.js"></script>
<script src="resources/js/echarts/echarts.min.js"></script>
<script src="resources/js/moment.js"></script>
<script src="resources/js/sheetJS/xlsx.full.min.js"></script>

<style>
	.RigthBox {background: #162B42;}
	.dataBox {
		position: absolute;
		top: 0;
		left: 0;
		z-index: 1;
	}

	#alarmRecentTable, #alarmTop20Table, #chemicalTable {table-layout: fixed;}
	#alarmRecentTable tr, #alarmTop20Table tr, #chemicalTable tr {border-bottom: 1px solid #4C5871;}
	#alarmRecentTable tbody tr td, #alarmTop20Table tbody tr td, #chemicalTable tbody tr td {color:#EAEAEC; height: 28px; font-size: 12px; padding: 2px 4px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 0;}
	#alarmRecentTable tbody tr:hover, #alarmTop20Table tbody tr:hover, #chemicalTable tbody tr:hover {background: rgba(58, 231, 255, 0.1);}
	.grid-th {color: #8899AA; font-size: 12px; padding: 4px 4px; font-weight: bold; position: sticky; top: 0; background: #162B42; z-index: 1;}
	.grid-th .col-resize {position: absolute; right: 0; top: 0; width: 5px; height: 100%; cursor: col-resize; z-index: 2;}

	.scrollBox::-webkit-scrollbar{background: #3e4961; width: 12px; height: 12px;}
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
	<div class="dataBox" id="chartBox1" style="top: 290px; left: 50px; width: 785px; height: 450px;">
		<div style="display:flex; align-items:center; gap:6px; padding:2px 10px 2px 90px; height:25px;">
			<select id="chart1Type" style="background:#1A324B; color:#FFF; border:1px solid #4C5871; padding:3px 8px; font-size:13px; border-radius:4px; cursor:pointer;">
				<option value="water">물생산량 (TON)</option>
				<option value="intensity">전력원단위 (kWh/TON)</option>
				<option value="chemical">약품사용량</option>
			</select>
			<label style="color:#FFF; font-size:12px; cursor:pointer;"><input type="radio" name="rdo_chart1" checked> 금일</label>
			<label style="color:#FFF; font-size:12px; cursor:pointer;"><input type="radio" name="rdo_chart1"> 일별</label>
			<label style="color:#FFF; font-size:12px; cursor:pointer;"><input type="radio" name="rdo_chart1"> 월별</label>
			<label style="color:#FFF; font-size:12px; cursor:pointer;"><input type="radio" name="rdo_chart1"> 년도별</label>
			<button id="btnChart1Excel" onclick="exportChart1Excel()" style="background:#1A324B; color:#FFF; border:1px solid #4C5871; padding:2px 8px; font-size:12px; border-radius:4px; cursor:pointer; margin-left:auto;">엑셀</button>
		</div>
		<div id="chart1" style="width:100%; height:calc(100% - 25px);"></div>
	</div>
	<div class="dataBox" id="chartBox2" style="top: 280px; left: 985px; width: 465px; height: 360px; background: #1A324B; border-radius: 8px;">
		<div id="chart2" style="width: 100%; height: 360px;"></div>
	</div>
	<!-- 약품 사용현황 -->
	<div class="dataBox" id="gridBox3" style="top: 820px; left: 50px; width: 620px; height: 215px;">
		<div class="scrollBox" style="width: 100%; height: 100%; overflow: auto;">
			<table id="chemicalTable" style="width: 100%; border-collapse: collapse;">
				<colgroup>
					<col style="width: 70px;"/>
					<col style="width: 95px;"/>
					<col style="width: 80px;"/>
					<col style="width: 80px;"/>
					<col style="width: 75px;"/>
					<col style="width: 85px;"/>
					<col/>
				</colgroup>
				<thead>
					<tr style="border-bottom: 2px solid #4C5871;">
						<td class="grid-th">약품명<div class="col-resize"></div></td>
						<td class="grid-th">약품사용처<div class="col-resize"></div></td>
						<td class="grid-th" style="text-align: right;">금일 사용량(L)<div class="col-resize"></div></td>
						<td class="grid-th" style="text-align: right;">전일 사용량(L)<div class="col-resize"></div></td>
						<td class="grid-th" style="text-align: right;">약품재고<div class="col-resize"></div></td>
						<td class="grid-th">약품태그<div class="col-resize"></div></td>
						<td class="grid-th">약품상세</td>
					</tr>
				</thead>
				<tbody id="chemicalBody">
				</tbody>
			</table>
		</div>
	</div>
	<!-- 알람 발생 현황 (금일 최근 10건) -->
	<div class="dataBox" id="gridBox1" style="top: 820px; left: 680px; width: 450px; height: 215px;">
		<div class="scrollBox" style="width: 100%; height: 100%; overflow: auto;">
			<table id="alarmRecentTable" style="width: 100%; border-collapse: collapse;">
				<colgroup>
					<col style="width: 120px;"/>
					<col style="width: 80px;"/>
					<col/>
					<col style="width: 70px;"/>
					<col style="width: 70px;"/>
				</colgroup>
				<thead>
					<tr style="border-bottom: 2px solid #4C5871;">
						<td class="grid-th">발생 시간<div class="col-resize"></div></td>
						<td class="grid-th">경보 위치<div class="col-resize"></div></td>
						<td class="grid-th">발생 상세<div class="col-resize"></div></td>
						<td class="grid-th">경보 종류<div class="col-resize"></div></td>
						<td class="grid-th">태그 종류</td>
					</tr>
				</thead>
				<tbody id="alarmRecentBody">
				</tbody>
			</table>
		</div>
	</div>
	<!-- 알람 발생 TOP 10 (금일 TAG별 건수) -->
	<div class="dataBox" id="gridBox2" style="top: 700px; left: 1500px; width: 375px; height: 200px;">
		<div class="scrollBox" style="width: 100%; height: 100%; overflow: auto;">
			<table id="alarmTop20Table" style="width: 100%; border-collapse: collapse;">
				<colgroup>
					<col style="width: 30px;"/>
					<col style="width: 90px;"/>
					<col/>
					<col style="width: 55px;"/>
				</colgroup>
				<thead>
					<tr style="border-bottom: 2px solid #4C5871;">
						<td class="grid-th">#<div class="col-resize"></div></td>
						<td class="grid-th">경보위치<div class="col-resize"></div></td>
						<td class="grid-th">발생 상세<div class="col-resize"></div></td>
						<td class="grid-th" style="text-align: right;">발생건수</td>
					</tr>
				</thead>
				<tbody id="alarmTop20Body">
				</tbody>
			</table>
		</div>
	</div>
	<script>
		var canvas_id = "#Graphics1";

		let chartBoxArr = [
			{boxId: "chartBox1", width: 785, height: 450, left: 50, top: 270, chart: [null]},
			{boxId: "chartBox2", width: 465, height: 360, left: 875, top: 300, chart: [null, null]},
			{boxId: "gridBox3", width: 610, height: 230, left: 60, top: 800},
			{boxId: "gridBox1", width: 610, height: 230, left: 725, top: 800},
			{boxId: "gridBox2", width: 375, height: 230, left: 1390, top: 800}
		];
/* 
		// ============================================================
		// 시설물 상태 TAG 설정
		// XML의 effectByImagelist에서 자동 처리됨
		// - operValue="0" → Off 이미지 (정지)
		// - operValue="1" → On 이미지 (가동)
		// ============================================================
		const facilityStatusTags_BAK = [
		    // 취수구
			"CDSWSS.M116A_FO_STS.F_CV,CDSWSS.M116B_FO_STS.F_CV,CDSWSS.M116C_FO_STS.F_CV",
			// 취수펌프장
			"CDSWSS.M106A_RUN_STS.F_CV,CDSWSS.M106B_RUN_STS.F_CV,CDSWSS.M106C_RUN_STS.F_CV",      
			// 원수저류조
			"CDSWSS.M111A_FO_STS.F_CV,CDSWSS.M111B_FO_STS.F_CV",
            // 전처리(DAF)			
			"CDSWSS.DAF_01_INSER_MODE.F_CV,CDSWSS.DAF_02_INSER_MODE.F_CV,CDSWSS.DAF_03_INSER_MODE.F_CV,CDSWSS.DAF_04_INSER_MODE.F_CV,CDSWSS.DAF_05_INSER_MODE.F_CV",      
			// 전처리(DMGF)
			"CDSWSS.DMGF_A_ON_ST.F_CV,CDSWSS.DMGF_B_ON_ST.F_CV,CDSWSS.DMGF_C_ON_ST.F_CV,CDSWSS.DMGF_D_ON_ST.F_CV,CDSWSS.DMGF_E_ON_ST.F_CV,CDSWSS.DMGF_F_ON_ST.F_CV,CDSWSS.DMGF_H_ON_ST.F_CV,CDSWSS.DMGF_I_ON_ST.F_CV,CDSWSS.DMGF_J_ON_ST.F_CV,CDSWSS.DMGF_K_ON_ST.F_CV,CDSWSS.DMGF_L_ON_ST.F_CV,CDSWSS.DMGF_M_ON_ST.F_CV,CDSWSS.DMGF_N_ON_MODE.F_CV",     
            // SWRO
			"CDSWSS.SWRO_A_RUN_STS.F_CV,CDSWSS.SWRO_B_RUN_STS.F_CV,CDSWSS.SWRO_C_RUN_STS.F_CV,CDSWSS.SWRO_D_RUN_STS.F_CV,CDSWSS.SWRO_E_RUN_STS.F_CV,CDSWSS.SWRO_F_RUN_STS.F_CV",   
            // BWRO			
			"CDSWSS.BWRO_A_RUN_STS.F_CV,CDSWSS.BWRO_B_RUN_STS.F_CV,CDSWSS.BWRO_C_RUN_STS.F_CV,CDSWSS.BWRO_D_RUN_STS.F_CV,CDSWSS.BWRO_E_RUN_STS.F_CV,CDSWSS.BWRO_F_RUN_STS.F_CV",     
			// 생산수조
			"CDSWSS.M448A_FO_STS.F_CV,CDSWSS.M448B_FO_STS.F_CV",      
			// 에너지회수장치
			"CDSWSS.M416A_FO_STS.F_CV,CDSWSS.M416B_FO_STS.F_CV,CDSWSS.M416C_FO_STS.F_CV,CDSWSS.M416D_FO_STS.F_CV,CDSWSS.M416E_FO_STS.F_CV,CDSWSS.M416F_FO_STS.F_CV"       
		];
		 */
		const facilityStatusTags = {
			//취수펌프장
			"RCS1": ["RCS1_PLC_STAT02","RCS1_PLC_STAT03"],
			//전전처리(DAF)
			"RCS2": ["RCS2_PLC_STAT02","RCS2_PLC_STAT03"],
			//RO(SWRO,BWRO)
			"RCS4": ["RCS4A_PLC_STAT02","RCS4A_PLC_STAT03","RCS4B_PLC_STAT02","RCS4B_PLC_STAT03","RCS4C_PLC_STAT03","RCS4D_PLC_STAT03","RCS4C_PLC_STAT02","RCS4E_PLC_STAT02","RCS4D_PLC_STAT02","RCS4E_PLC_STAT03","RCS4F_PLC_STAT02","RCS4F_PLC_STAT03"],
			//폐수처리동
			"RCS6": ["RCS6_PLC_STAT02","RCS6_PLC_STAT03"],
			//원수저류조
			"RCSM": ["RCSM_PLC_STAT02","RCSM_PLC_STAT03"],
			//전처리(DMGF)
			"RCS3": ["RCS3_PLC_STAT02","RCS3_PLC_STAT03"],
			//FLUSHING
			"RCSRO": ["RCSRO_PLC_STAT02","RCSRO_PLC_STAT03"]
		}
		

		// 생산수 수질 기준치 설정 (오각형 그래프)
		const chart2RefConfig = [
			{tag: "CL482",  name: "염소이온",   refVal: 20,   label: "≤20"},
			{tag: "CE482",  name: "전기전도도", refVal: 150,  label: "≤150"},
			{tag: "TDS482", name: "TDS",        refVal: 65,   label: "≤65"},
			{tag: "HAD482", name: "총경도",     refVal: 2.5,  label: "≤2.5"},
			{tag: "PH482",  name: "pH",         refVal: 7.5,  label: "6.5~7.5"}
		];

		/* 
		// 전체 TAG 목록 통합 (시설물 상태)
		function getAllTagList() {
			let allTags = [];
			// 시설물 상태 태그 (쉼표로 구분된 태그들을 개별 분리)
			facilityStatusTags_BAK.forEach(tagGroup => {
				tagGroup.split(",").forEach(tag => {
					allTags.push(tag.trim());
				});
			});
			return [...new Set(allTags)];
		}
		const allTagList = getAllTagList();
		 */
		
		
		
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

		// 소비 전력량/사용금액 조회 및 업데이트
		function loadPowerData() {
			let today = new Date();
			let dateStr = today.getFullYear() +
				String(today.getMonth() + 1).padStart(2, "0") +
				String(today.getDate()).padStart(2, "0");

			// 현재 월 기준 계절 판단 (W:겨울, S:여름, F:봄/가을)
			let month = today.getMonth() + 1;
			let season = "F";
			if (month >= 11 || month <= 2) season = "W";
			else if (month >= 6 && month <= 8) season = "S";

			// 금일 소비 전력량 조회
			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "getTodayPowerUsage",
				dataType: "json",
				data: JSON.stringify({date: dateStr}),
				success: function(res) {
					if (res && res.length > 0) {
						let totalUsage = 0;
						let hasNegative = false;
						res.forEach(function(item) {
							let val = Number(item.TODAY_USAGE || 0);
							if (val < 0) hasNegative = true;
							totalUsage += val;
						});
						// 음수 값이면 표시하지 않고 다음 갱신 대기
						if (hasNegative || totalUsage < 0) {
// 							console.log("[db0102] 소비 전력량 음수 감지 → 표시 스킵, 다음 갱신 대기");
							return;
						}
						// MWh 포맷팅 (소수점 2자리)
						let formattedUsage = totalUsage.toLocaleString(undefined, {minimumFractionDigits: 2, maximumFractionDigits: 2});
						updateXmlText("VL_SJR", formattedUsage);
// 						console.log("[db0102] 소비 전력량:", formattedUsage, "MWh");
					}
				},
				error: function(e) {
					console.error("소비 전력량 조회 실패:", e);
				}
			});

			// 금일 소비 요금 조회
			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "getTodayPowerCost",
				dataType: "json",
				data: JSON.stringify({date: dateStr, season: season}),
				success: function(res) {
					if (res && res.length > 0) {
						let totalCost = Number(res.find(e=> e.FACILITY_ID == '합계')?.TOTAL_COST || 0);
						if (totalCost < 0) {
// 							console.log("[db0102] 사용금액 음수 감지 → 표시 스킵, 다음 갱신 대기");
							return;
						}
						let totalFormattedCost = Math.round(totalCost).toLocaleString();
						updateXmlText("VL_WON", totalFormattedCost);
						
// 						console.log("[db0102] 사용금액:", totalFormattedCost, "원");
					}
				},
				error: function(e) {
					console.error("사용금액 조회 실패:", e);
				}
			});
		}

		// XML 렌더링된 요소의 텍스트 업데이트
		function updateXmlText(elementName, value) {
			// bizRender의 shapeNames를 통해 접근
			let workspace = $(canvas_id).data("BizRender");
			if (workspace && workspace.shapeNames) {
				let shape = workspace.shapeNames[elementName];
				if (shape) {
					shape.fill.text = value;
					shape.bDraw = true;  // 다시 그리기 플래그
// 					console.log("[updateXmlText] " + elementName + " = " + value);
					return;
				}
			}
			console.warn("[updateXmlText] shape not found:", elementName);
		}

		// 처음 로드 다되면
		window.onload = function() {
			/* 
			$(canvas_id).bizRender( {
				//width : 1810,
				//height : 1080,
				//left: 110,
				layoutPath : "../../resources/layout/",
				imagesPath : "../../resources/images/biznexus/",
				urlPrefix : "",
				fileName : "db0102_2_BAK",
				interval : 1000,
				dest: "historian",
				tagList: allTagList,  // 전체 TAG 목록 (시설물 상태 + 차트용)
				onTimeChanged: function(date){
				},
				onValueChanged: function(tagValues){
					consolel.log(tagValues)
				},
				onItemClick: function(e){
				},
			});
			 */
			const tagList = Object.values(facilityStatusTags).flat();
			$(canvas_id).bizRender( {
				//width : 1810,
				//height : 1080,
				//left: 110,
				layoutPath : "../../resources/layout/",
				imagesPath : "../../resources/images/biznexus/",
				urlPrefix : "",
				fileName : "db0102_2",
				interval : 1000,
				dest: "historian",
				tagList: tagList, // 전체 TAG 목록 (시설물 상태)
				onTimeChanged: function(date){
				},
				onValueChanged: function(tagValues){
					consolel.log("tagVal: "+tagValues);
					Object.entries(facilityStatusTags).forEach(([key, tags]) => {
						const statVal = tags.every(tag => tagValues?.[tag]?.value === 1);
						$(canvas_id).bizRender("setVal", key, statVal);
					});
				},
				onItemClick: function(e){
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

			// 소비 전력량/사용금액 데이터 로드 (XML 렌더링 완료 후)
			setTimeout(function() {
				loadPowerData();
				// 1분마다 갱신
				setInterval(loadPowerData, 60000);
			}, 2000);  // bizRender XML 로드 완료 대기

			// 알람 데이터 로드 및 1분마다 갱신
			loadAlarmData();
			setInterval(loadAlarmData, 60000);

			// 약품 사용현황 로드 및 1분마다 갱신
			loadChemicalUsage();
			setInterval(loadChemicalUsage, 60000);

			// 칼럼 리사이즈 초기화
			initColumnResize();
		};

		// ============================================================
		// Chart1: 누계 실적 (ECharts)
		// ============================================================
		var chart1Instance = null;
		var chart1CurrentType = "water";   // water | intensity | chemical
		var chart1CurrentPeriod = 0;       // 0=금일, 1=일별, 2=월별, 3=년도별

		function initChart1() {
			chart1Instance = echarts.init(document.getElementById("chart1"));
			chartBoxArr[0].chart[0] = chart1Instance;

			// 드롭다운 변경 이벤트
			$("#chart1Type").on("change", function() {
				chart1CurrentType = $(this).val();
				loadChart1Data(chart1CurrentType, chart1CurrentPeriod);
			});

			// 라디오 버튼 변경 이벤트
			$("input[name='rdo_chart1']").on("change", function() {
				chart1CurrentPeriod = $("input[name='rdo_chart1']").index(this);
				loadChart1Data(chart1CurrentType, chart1CurrentPeriod);
			});

			// 초기 로드
			loadChart1Data(chart1CurrentType, chart1CurrentPeriod);

			// 1분마다 갱신
			setInterval(function() {
				loadChart1Data(chart1CurrentType, chart1CurrentPeriod);
			}, 60000);

			// 윈도우 리사이즈 대응
			window.addEventListener("resize", function() {
				if (chart1Instance) chart1Instance.resize();
			});
		};

		function getDateParams() {
			var today = moment();
			return {
				date: today.format("YYYYMMDD"),
				yesterdayDate: moment().subtract(1, "days").format("YYYYMMDD")
			};
		}

		// 차트 타입 + 기간별 URL 매핑
		function getChart1Url(chartType, period) {
			var urlMap = {
				water: ["getHourlyWaterProduction", "getDailyWaterProduction", "getMonthlyWaterProduction", "getYearlyWaterProduction"],
				intensity: ["getHourlyPowerIntensity", "getDailyPowerIntensity", "getMonthlyPowerIntensity", "getYearlyPowerIntensity"],
				chemical: [null, "getDailyChemicalUsage", "getMonthlyChemicalUsage", "getYearlyChemicalUsage"]
			};
			return urlMap[chartType] ? urlMap[chartType][period] : null;
		}

		function loadChart1Data(chartType, period) {
			if (chartType === "chemical" && period === 0) {
				loadChart1Chemical();
				return;
			}

			var url = getChart1Url(chartType, period);
			if (!url) return;

			var params = getDateParams();

			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: url,
				dataType: "json",
				data: JSON.stringify(params),
				success: function(res) {
					if (chartType === "chemical") {
						renderChart1ChemicalPeriod(res, period);
					} else {
						renderChart1Line(res, chartType, period);
					}
				},
				error: function(e) {
					console.error("[chart1] 데이터 로드 실패:", url, e);
				}
			});
		}

		function renderChart1Line(data, chartType, period) {
			if (!chart1Instance || !data) return;

			var xLabels = [];
			var todayData = [];
			var yesterdayData = [];
			var hasTwoSeries = (period === 0); // 금일만 금일/전일 2시리즈

			var unitText = chartType === "water" ? "TON" : (chartType === "chemical" ? "L" : "kWh/TON");

			data.forEach(function(item) {
				var key = item.HOUR_KEY || item.DAY_KEY || item.MONTH_KEY || item.YEAR_KEY || "";
				// X축 라벨 포맷
				if (period === 0) {
					xLabels.push(key + ":00");
				} else if (period === 1) {
					xLabels.push(key.substring(4, 6) + "/" + key.substring(6, 8));
				} else if (period === 2) {
					xLabels.push(key.substring(0, 4) + "/" + key.substring(4, 6));
				} else {
					xLabels.push(key);
				}
				todayData.push(item.TODAY_VAL != null ? Number(item.TODAY_VAL) : null);
				if (hasTwoSeries) {
					yesterdayData.push(item.YESTERDAY_VAL != null ? Number(item.YESTERDAY_VAL) : null);
				}
			});

			var series = [{
				name: hasTwoSeries ? "금일" : (chartType === "water" ? "물생산량" : "전력원단위"),
				type: "line",
				data: todayData,
				smooth: true,
				symbol: "circle",
				symbolSize: 4,
				lineStyle: { color: "#3AE7FF", width: 2 },
				itemStyle: { color: "#3AE7FF" },
				areaStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
					{offset: 0, color: "rgba(58, 231, 255, 0.3)"},
					{offset: 1, color: "rgba(58, 231, 255, 0.02)"}
				])}
			}];

			if (hasTwoSeries) {
				series.push({
					name: "전일",
					type: "line",
					data: yesterdayData,
					smooth: true,
					symbol: "circle",
					symbolSize: 4,
					lineStyle: { color: "#FF5BC7", width: 2, type: "dashed" },
					itemStyle: { color: "#FF5BC7" }
				});
			}

			var option = {
				backgroundColor: "transparent",
				tooltip: {
					trigger: "axis",
					axisPointer: { type: "cross", crossStyle: { color: "#999" } },
					formatter: function(params) {
						var html = params[0].axisValue + "<br/>";
						params.forEach(function(p) {
							if (p.value != null) {
								html += p.marker + " " + p.seriesName + ": " + Number(p.value).toLocaleString(undefined, {minimumFractionDigits: 2, maximumFractionDigits: 2}) + " " + unitText + "<br/>";
							}
						});
						return html;
					}
				},
				legend: {
					show: hasTwoSeries,
					right: 20,
					top: 5,
					textStyle: { color: "#FFF", fontSize: 12 },
					data: hasTwoSeries ? ["금일", "전일"] : []
				},
				grid: { left: 60, right: 20, top: 30, bottom: 25 },
				xAxis: {
					type: "category",
					data: xLabels,
					axisLabel: { color: "#FFF", fontSize: 11 },
					axisLine: { lineStyle: { color: "#FFFFFF55" } },
					splitLine: { show: false }
				},
				yAxis: {
					type: "value",
					axisLabel: { color: "#FFF", fontSize: 11 },
					axisLine: { lineStyle: { color: "#FFFFFF55" } },
					splitLine: { lineStyle: { color: "#FFFFFF33" } }
				},
				series: series
			};

			chart1Instance.setOption(option, true);
		}

		// 약품사용량 bar chart (기존 getChemicalUsage 재사용)
		function loadChart1Chemical() {
			var params = getDateParams();

			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "getChemicalUsage",
				dataType: "json",
				data: JSON.stringify({today: params.date, yesterday: params.yesterdayDate}),
				success: function(res) {
					renderChart1Chemical(res);
				},
				error: function(e) {
					console.error("[chart1] 약품사용량 로드 실패:", e);
				}
			});
		}

		function renderChart1Chemical(data) {
			if (!chart1Instance || !data) return;

			// 합산 그룹 처리 (loadChemicalUsage와 동일 로직)
			var mergeMap = {};
			var mergeRendered = {};
			var rows = [];

			data.forEach(function(item) {
				var tagNm = item.TAG_NM || "";
				var info = chemicalTagMap[tagNm] || {name: tagNm, location: "-"};
				if (info.mergeKey) {
					if (!mergeMap[info.mergeKey]) {
						mergeMap[info.mergeKey] = {today: 0, yesterday: 0};
					}
					mergeMap[info.mergeKey].today += Number(item.TODAY_USAGE || 0);
					mergeMap[info.mergeKey].yesterday += Number(item.YESTERDAY_USAGE || 0);
				}
			});

			data.forEach(function(item) {
				var tagNm = item.TAG_NM || "";
				var info = chemicalTagMap[tagNm] || {name: tagNm, location: "-"};
				if (info.mergeKey) {
					if (!mergeRendered[info.mergeKey]) {
						mergeRendered[info.mergeKey] = true;
						var cfg = chemicalMergeConfig[info.mergeKey];
						rows.push({
							name: cfg.name + "\n(" + cfg.location + ")",
							today: mergeMap[info.mergeKey].today,
							yesterday: mergeMap[info.mergeKey].yesterday
						});
					}
				} else {
					rows.push({
						name: info.name + "\n(" + info.location + ")",
						today: Number(item.TODAY_USAGE || 0),
						yesterday: Number(item.YESTERDAY_USAGE || 0)
					});
				}
			});

			var xLabels = rows.map(function(r) { return r.name; });
			var todayVals = rows.map(function(r) { return r.today; });
			var yesterdayVals = rows.map(function(r) { return r.yesterday; });

			var option = {
				backgroundColor: "transparent",
				tooltip: {
					trigger: "axis",
					axisPointer: { type: "shadow" }
				},
				legend: {
					show: true,
					right: 20,
					top: 5,
					textStyle: { color: "#FFF", fontSize: 12 },
					data: ["금일", "전일"]
				},
				grid: { left: 60, right: 20, top: 30, bottom: 25 },
				xAxis: {
					type: "category",
					data: xLabels,
					axisLabel: { color: "#FFF", fontSize: 10, interval: 0, rotate: 30 },
					axisLine: { lineStyle: { color: "#FFFFFF55" } }
				},
				yAxis: {
					type: "value",
					axisLabel: { color: "#FFF", fontSize: 11 },
					axisLine: { lineStyle: { color: "#FFFFFF55" } },
					splitLine: { lineStyle: { color: "#FFFFFF33" } }
				},
				series: [{
					name: "금일",
					type: "bar",
					data: todayVals,
					itemStyle: { color: "#3AE7FF" },
					barGap: "10%"
				}, {
					name: "전일",
					type: "bar",
					data: yesterdayVals,
					itemStyle: { color: "#FF5BC7" }
				}]
			};

			chart1Instance.setOption(option, true);
		}

		// 약품별 line chart (일별/월별/년도별)
		var chemicalLineColors = [
			"#3AE7FF", "#FF5BC7", "#FFD700", "#00FF88", "#FF6B6B",
			"#B388FF", "#FF8A65", "#4DD0E1", "#AED581", "#F48FB1",
			"#80DEEA", "#CE93D8", "#FFB74D", "#81C784", "#E57373"
		];

		function renderChart1ChemicalPeriod(data, period) {
			if (!chart1Instance || !data) return;

			// 1) X축 키 수집 (순서 유지)
			var keyField = period === 1 ? "DAY_KEY" : (period === 2 ? "MONTH_KEY" : "YEAR_KEY");
			var xKeysSet = {};
			var xKeys = [];
			data.forEach(function(item) {
				var k = item[keyField] || "";
				if (!xKeysSet[k]) { xKeysSet[k] = true; xKeys.push(k); }
			});

			// X축 라벨 포맷
			var xLabels = xKeys.map(function(k) {
				if (period === 1) return k.substring(4, 6) + "/" + k.substring(6, 8);
				if (period === 2) return k.substring(0, 4) + "/" + k.substring(4, 6);
				return k;
			});

			// 2) TAG_NM별 데이터 그룹핑 + mergeKey 합산
			var chemMap = {};  // key: displayName, value: {data: {xKey: val}}
			var chemOrder = [];

			data.forEach(function(item) {
				var tagNm = item.TAG_NM || "";
				var val = Number(item.USAGE_VAL || 0);
				var xKey = item[keyField] || "";
				var info = chemicalTagMap[tagNm] || {name: tagNm, location: "-"};
				var displayName;

				if (info.mergeKey) {
					var cfg = chemicalMergeConfig[info.mergeKey];
					displayName = cfg.name + "(" + cfg.location + ")";
				} else {
					displayName = info.name + "(" + info.location + ")";
				}

				if (!chemMap[displayName]) {
					chemMap[displayName] = {};
					chemOrder.push(displayName);
				}
				chemMap[displayName][xKey] = (chemMap[displayName][xKey] || 0) + val;
			});

			// 3) 시리즈 생성
			var series = [];
			var legendData = [];
			var colorIdx = 0;

			chemOrder.forEach(function(name) {
				var seriesData = xKeys.map(function(k) {
					var v = chemMap[name][k];
					return (v != null && v > 0) ? Math.round(v * 100) / 100 : null;
				});

				// 모든 값이 null/0이면 시리즈 제외
				var hasData = seriesData.some(function(v) { return v != null && v > 0; });
				if (!hasData) return;

				legendData.push(name);
				series.push({
					name: name,
					type: "line",
					data: seriesData,
					smooth: true,
					symbol: "circle",
					symbolSize: 4,
					lineStyle: { color: chemicalLineColors[colorIdx % chemicalLineColors.length], width: 2 },
					itemStyle: { color: chemicalLineColors[colorIdx % chemicalLineColors.length] }
				});
				colorIdx++;
			});

			var option = {
				backgroundColor: "transparent",
				tooltip: {
					trigger: "axis",
					axisPointer: { type: "cross", crossStyle: { color: "#999" } },
					formatter: function(params) {
						var html = params[0].axisValue + "<br/>";
						params.forEach(function(p) {
							if (p.value != null) {
								html += p.marker + " " + p.seriesName + ": " + Number(p.value).toLocaleString(undefined, {minimumFractionDigits: 2, maximumFractionDigits: 2}) + " L<br/>";
							}
						});
						return html;
					}
				},
				legend: {
					show: true,
					type: "scroll",
					right: 10,
					top: 0,
					textStyle: { color: "#FFF", fontSize: 10 },
					pageTextStyle: { color: "#FFF" },
					pageIconColor: "#3AE7FF",
					pageIconInactiveColor: "#555",
					data: legendData
				},
				grid: { left: 60, right: 20, top: 40, bottom: 25 },
				xAxis: {
					type: "category",
					data: xLabels,
					axisLabel: { color: "#FFF", fontSize: 11 },
					axisLine: { lineStyle: { color: "#FFFFFF55" } },
					splitLine: { show: false }
				},
				yAxis: {
					type: "value",
					axisLabel: { color: "#FFF", fontSize: 11 },
					axisLine: { lineStyle: { color: "#FFFFFF55" } },
					splitLine: { lineStyle: { color: "#FFFFFF33" } }
				},
				series: series
			};

			chart1Instance.setOption(option, true);
		}

		// ============================================================
		// 엑셀 다운로드 (Chart1 데이터)
		// ============================================================
		function exportChart1Excel() {
			if (!chart1Instance) return;
			var opt = chart1Instance.getOption();
			if (!opt || !opt.series || opt.series.length === 0) {
				alert("다운로드할 데이터가 없습니다.");
				return;
			}

			var typeNames = {water: "물생산량", intensity: "전력원단위", chemical: "약품사용량"};
			var periodNames = ["금일", "일별", "월별", "년도별"];
			var typeName = typeNames[chart1CurrentType] || chart1CurrentType;
			var periodName = (chart1CurrentType === "chemical") ? "" : periodNames[chart1CurrentPeriod] || "";
			var sheetName = typeName + (periodName ? " " + periodName : "");

			var xData = opt.xAxis[0].data || [];
			var series = opt.series;

			// 헤더 행 생성
			var header = ["구분"];
			series.forEach(function(s) { header.push(s.name); });

			// 데이터 행 생성
			var rows = [header];
			for (var i = 0; i < xData.length; i++) {
				var row = [xData[i]];
				series.forEach(function(s) {
					row.push(s.data[i] != null ? s.data[i] : 0);
				});
				rows.push(row);
			}

			// SheetJS로 엑셀 생성
			var ws = XLSX.utils.aoa_to_sheet(rows);

			// 컬럼 너비 설정
			var colWidths = [{wch: 20}];
			for (var c = 1; c < header.length; c++) colWidths.push({wch: 15});
			ws["!cols"] = colWidths;

			var wb = XLSX.utils.book_new();
			XLSX.utils.book_append_sheet(wb, ws, sheetName.substring(0, 31));

			var fileName = "누계실적_" + typeName + (periodName ? "_" + periodName : "") + "_" + moment().format("YYYYMMDD_HHmmss") + ".xlsx";
			XLSX.writeFile(wb, fileName);
		}

		function initChart2() {
			var categories = chart2RefConfig.map(function(r) {
				return r.name + "\n(" + r.label + ")";
			});

			chartBoxArr[1].chart[0] = Highcharts.chart("chart2", {
				chart: {
					polar: true,
					type: "line",
					backgroundColor: "#1A324B",
					height: 360,
					spacingTop: 10,
					spacingBottom: 10,
					spacingLeft: 10,
					spacingRight: 10
				},
				credits: {enabled: false},
				exporting: {enabled: false},
				title: {text: ""},
				legend: {
					layout: "horizontal",
					align: "center",
					verticalAlign: "bottom",
					symbolWidth: 20,
					symbolRadius: 0,
					itemDistance: 20,
					itemStyle: {
						color: "#FFFFFF",
						fontSize: "13px",
						fontWeight: "normal"
					},
					itemHoverStyle: {
						color: "#DDDDDD"
					}
				},
				plotOptions: {
					series: {
						lineWidth: 2,
						marker: {
							enabled: true,
							radius: 4
						}
					}
				},
				tooltip: {
					shared: true,
					useHTML: true,
					formatter: function() {
						var idx = this.points[0].point.index;
						var ref = chart2RefConfig[idx];
						var s = '<b>' + ref.name + '</b><br>';
						this.points.forEach(function(point) {
							s += '<span style="color:' + point.color + '">\u25CF</span> '
								+ point.series.name + ': ';
							if (point.series.name === "\uC815\uC0C1 \uAE30\uC900\uCE58") {
								s += ref.label;
							} else {
								var actual = point.point.options.actual;
								s += actual + ' (' + point.y.toFixed(1) + '%)';
							}
							s += '<br>';
						});
						return s;
					}
				},
				xAxis: {
					categories: categories,
					labels: {
						style: {
							color: "#FFFFFF",
							fontSize: "12px"
						},
						distance: 20
					},
					tickmarkPlacement: "on",
					lineWidth: 0,
					gridLineColor: "rgba(255,255,255,0.3)"
				},
				yAxis: {
					gridLineInterpolation: "polygon",
					gridLineColor: "rgba(255,255,255,0.15)",
					lineWidth: 0,
					min: 0,
					tickInterval: 50,
					labels: {
						enabled: true,
						format: "{value}%",
						style: {
							color: "rgba(255,255,255,0.5)",
							fontSize: "10px"
						}
					},
					plotLines: [{
						value: 100,
						color: "rgba(0, 200, 83, 0.6)",
						width: 2,
						dashStyle: "Dash"
					}]
				},
				pane: {
					size: "55%",
					startAngle: 0
				},
				series: [{
					name: "\uC815\uC0C1 \uAE30\uC900\uCE58",
					type: "area",
					color: "rgba(0, 200, 83, 0.8)",
					fillColor: "rgba(0, 200, 83, 0.1)",
					dashStyle: "Dash",
					pointPlacement: "on",
					data: chart2RefConfig.map(function(r) { return {y: 100, actual: r.refVal}; }),
					dataLabels: {
						enabled: true,
						formatter: function() { return this.point.actual; },
						style: {
							color: "#00C853",
							textOutline: "none",
							fontSize: "12px",
							fontWeight: "bold"
						}
					}
				}, {
					name: "\uD604\uC7AC\uAC12 (1\uBD84\uC804)",
					color: "#3AE7FF",
					pointPlacement: "on",
					data: chart2RefConfig.map(function() { return {y: 0, actual: 0}; }),
					dataLabels: {
						enabled: true,
						formatter: function() {
							if (this.point.actual === 0) return "";
							return this.point.actual;
						},
						style: {
							color: "#3AE7FF",
							textOutline: "none",
							fontSize: "14px",
							fontWeight: "bold"
						}
					}
				}],
				responsive: {
					rules: [{
						condition: {
							maxWidth: 1000
						},
						chartOptions: {
							legend: {
								align: "center",
								verticalAlign: "bottom",
								layout: "horizontal"
							},
							pane: {
								size: "55%"
							}
						}
					}]
				}
			});

			// 차트 생성 후 데이터 로드
			loadChart2Data();
			// 1분마다 자동 갱신
			setInterval(loadChart2Data, 60000);
		};

		// 생산수 수질 최신 데이터 조회 (TAGSN 490~494)
		var chart2TagOrder = chart2RefConfig.map(function(r) { return r.tag; });

		function loadChart2Data() {
			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "getWaterQualityLatest",
				dataType: "json",
				data: JSON.stringify({}),
				success: function(res) {
					var currentData = chart2RefConfig.map(function() { return {y: 0, actual: 0}; });

					if (res && res.length > 0) {
						res.forEach(function(item) {
							var idx = chart2TagOrder.indexOf(item.TAG_NM);
							if (idx >= 0) {
								var actual = Number(item.CURRENT_VAL || 0);
								var ref = chart2RefConfig[idx];
								var normalized = (actual / ref.refVal) * 100;
								var pointColor;
								if (ref.tag === "PH482") {
									pointColor = (actual < 6.5 || actual > 7.5) ? "#FF5252" : "#3AE7FF";
								} else {
									pointColor = normalized > 100 ? "#FF5252" : "#3AE7FF";
								}
								currentData[idx] = {
									y: Math.round(normalized * 10) / 10,
									actual: actual,
									color: pointColor
								};
							}
						});
					}

					chartBoxArr[1].chart[0].series[1].setData(currentData, true);
				},
				error: function(e) {
					console.error("생산수 수질 데이터 로드 실패:", e);
				}
			});
		}

		// ============================================================
		// 약품 사용현황 (TAGSN 400~417)
		// ============================================================
		const chemicalTagMap = {
			"FIQ101":  {name: "NaOCl",     location: "취수장"},
			"FIQ501":  {name: "H2SO4",     location: "전처리(DAF)"},
			"FIQ511":  {name: "FeCl3",     location: "전전처리(DAF)"},
			"FIQ521":  {name: "NaOCl",     location: "전전처리(DAF)"},
			"FIQ531":  {name: "폴리머",    location: "전전처리(DAF)"},
			"FIQ541A": {name: "NaOH",      location: "RO(A)", mergeKey: "FIQ541"},
			"FIQ541B": {name: "NaOH",      location: "RO(B)", mergeKey: "FIQ541"},
			"FIQ541C": {name: "NaOH",      location: "RO(C)", mergeKey: "FIQ541"},
			"FIQ551":  {name: "HCl",       location: "RO"},
			"FIQ561":  {name: "산화방지제", location: "RO"},
			"FIQ571":  {name: "스케일방지", location: "RO"},
			"FIQ581":  {name: "H2SO4",     location: "RO"},
			"FIQ621A": {name: "폴리머(음)", location: "폐수처리(A)", mergeKey: "FIQ621"},
			"FIQ621B": {name: "폴리머(음)", location: "폐수처리(B)", mergeKey: "FIQ621"},
			"FIQ631A": {name: "폴리머(양)", location: "폐수처리(A)", mergeKey: "FIQ631"},
			"FIQ631B": {name: "폴리머(양)", location: "폐수처리(B)", mergeKey: "FIQ631"},
			"FIQ631C": {name: "폴리머(양)", location: "폐수처리(C)", mergeKey: "FIQ631"},
			"FIQ611":  {name: "FeCl3",     location: "폐수처리"}
		};
		// 합산 그룹 설정 (mergeKey → 표시 정보)
		const chemicalMergeConfig = {
			"FIQ541": {name: "NaOH",      location: "RO"},
			"FIQ621": {name: "폴리머(음)", location: "폐수처리"},
			"FIQ631": {name: "폴리머(양)", location: "폐수처리"}
		};

		function loadChemicalUsage() {
			let today = new Date();
			let todayStr = today.getFullYear() +
				String(today.getMonth() + 1).padStart(2, "0") +
				String(today.getDate()).padStart(2, "0");
			let yesterday = new Date(today);
			yesterday.setDate(yesterday.getDate() - 1);
			let yesterdayStr = yesterday.getFullYear() +
				String(yesterday.getMonth() + 1).padStart(2, "0") +
				String(yesterday.getDate()).padStart(2, "0");

			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "getChemicalUsage",
				dataType: "json",
				data: JSON.stringify({today: todayStr, yesterday: yesterdayStr}),
				success: function(res) {
					let tbody = $("#chemicalBody");
					tbody.empty();
					if (res && res.length > 0) {
						// 1차: 합산 그룹 집계
						let mergeMap = {};
						res.forEach(function(item) {
							let tagNm = item.TAG_NM || "";
							let info = chemicalTagMap[tagNm] || {};
							if (info.mergeKey) {
								if (!mergeMap[info.mergeKey]) {
									mergeMap[info.mergeKey] = {today: 0, yesterday: 0, stock: 0, tags: [], descs: []};
								}
								let g = mergeMap[info.mergeKey];
								g.today += Number(item.TODAY_USAGE || 0);
								g.yesterday += Number(item.YESTERDAY_USAGE || 0);
								g.stock += Number(item.INVENTORY_VAL || 0);
								g.tags.push(tagNm);
								g.descs.push(item.TAG_DESC || "");
							}
						});

						// 2차: 원래 순서대로 행 생성 (합산 그룹은 첫 멤버 위치에 삽입)
						let mergeRendered = {};
						let rows = [];
						res.forEach(function(item) {
							let tagNm = item.TAG_NM || "";
							let info = chemicalTagMap[tagNm] || {name: tagNm, location: "-"};
							if (info.mergeKey) {
								if (!mergeRendered[info.mergeKey]) {
									mergeRendered[info.mergeKey] = true;
									let g = mergeMap[info.mergeKey];
									let cfg = chemicalMergeConfig[info.mergeKey];
									rows.push({
										name: cfg.name, location: cfg.location,
										today: g.today, yesterday: g.yesterday, stock: g.stock,
										tag: g.tags.join("/"), desc: g.descs.join(", ")
									});
								}
							} else {
								rows.push({
									name: info.name, location: info.location,
									today: Number(item.TODAY_USAGE || 0),
									yesterday: Number(item.YESTERDAY_USAGE || 0),
									stock: Number(item.INVENTORY_VAL || 0),
									tag: tagNm, desc: item.TAG_DESC || ""
								});
							}
						});

						var fmtNum = function(v) { return Number(v).toLocaleString(undefined, {minimumFractionDigits: 2, maximumFractionDigits: 2}); };
						rows.forEach(function(r) {
							let tr = $("<tr>");
							tr.append($("<td>").text(r.name));
							tr.append($("<td>").text(r.location));
							tr.append($("<td>").css("text-align", "right").text(fmtNum(r.today)));
							tr.append($("<td>").css("text-align", "right").text(fmtNum(r.yesterday)));
							tr.append($("<td>").css("text-align", "right").text(fmtNum(r.stock)));
							tr.append($("<td>").text(r.tag));
							tr.append($("<td>").text(r.desc).attr("title", r.desc));
							tbody.append(tr);
						});
					} else {
						tbody.html('<tr><td colspan="7" style="text-align:center; color:#8899AA;">데이터 없음</td></tr>');
					}
				},
				error: function(e) { console.error("약품 사용현황 조회 실패:", e); }
			});
		}

		// ============================================================
		// 알람 발생 현황 (금일 최근 10건) + 알람 발생 TOP 10 (금일 TAG별 건수)
		// ============================================================
		function getTodayRange() {
			let today = new Date();
			let startDate = today.getFullYear() +
				String(today.getMonth() + 1).padStart(2, "0") +
				String(today.getDate()).padStart(2, "0");
			return { startDate: startDate };
		}

		function loadAlarmRecent() {
			let range = getTodayRange();
			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "getAlarmRecent",
				dataType: "json",
				data: JSON.stringify(range),
				success: function(res) {
					let tbody = $("#alarmRecentBody");
					tbody.empty();
					if (res && res.length > 0) {
						res.forEach(function(item) {
							let tr = $("<tr>");
							tr.append($("<td>").text(item.OCCUR_DATE || ""));
							tr.append($("<td>").text(item.TAG_NAME || "").attr("title", item.TAG_NAME || ""));
							tr.append($("<td>").text(item.TAG_DESC || "").attr("title", item.TAG_DESC || ""));
							tr.append($("<td>").text(item.PROC_TYPE || ""));
							tr.append($("<td>").text(item.BLOCK_TYPE || ""));							
							tbody.append(tr);
						});
					} else {
						tbody.html('<tr><td colspan="5" style="text-align:center; color:#8899AA;">금일 알람 없음</td></tr>');
					}
				},
				error: function(e) { console.error("알람 발생 현황 조회 실패:", e); }
			});
		}

		function loadAlarmTop10() {
			let range = getTodayRange();
			$.ajax({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "getAlarmTop20",
				dataType: "json",
				data: JSON.stringify(range),
				success: function(res) {
					let tbody = $("#alarmTop20Body");
					tbody.empty();
					if (res && res.length > 0) {
						res.forEach(function(item) {
							let tr = $("<tr>");
							tr.append($("<td>").text(item.RANK_NO));
							tr.append($("<td>").text(item.TAG_NAME || "").attr("title", item.TAG_NAME || ""));
							tr.append($("<td>").text(item.TAG_DESC || "").attr("title", item.TAG_DESC || ""));
							tr.append($("<td>").css("text-align", "right").text(Number(item.ALM_COUNT).toLocaleString()));
							tbody.append(tr);
						});
					} else {
						tbody.html('<tr><td colspan="4" style="text-align:center; color:#8899AA;">금일 알람 없음</td></tr>');
					}
				},
				error: function(e) { console.error("알람 TOP 10 조회 실패:", e); }
			});
		}

		function loadAlarmData() {
			loadAlarmRecent();
			loadAlarmTop10();
		}

		// 칼럼 리사이즈 기능
		function initColumnResize() {
			document.querySelectorAll(".col-resize").forEach(function(handle) {
				handle.addEventListener("mousedown", function(e) {
					e.preventDefault();
					let th = this.parentElement;
					let table = th.closest("table");
					let colIndex = th.cellIndex;
					let col = table.querySelectorAll("colgroup col")[colIndex];
					let startX = e.pageX;
					let startWidth = th.offsetWidth;

					function onMouseMove(e) {
						let newWidth = startWidth + (e.pageX - startX);
						if (newWidth > 20) {
							col.style.width = newWidth + "px";
						}
					}

					function onMouseUp() {
						document.removeEventListener("mousemove", onMouseMove);
						document.removeEventListener("mouseup", onMouseUp);
					}

					document.addEventListener("mousemove", onMouseMove);
					document.addEventListener("mouseup", onMouseUp);
				});
			});
		}

		// 태그별 평균값 계산 - 0이 아닌 값만 (chart2RefConfig 기준)
	</script>
</body>
</html>