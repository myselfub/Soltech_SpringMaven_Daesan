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
<title>전력량 단가 관리</title>
<!-- 
	<script src="https://code.highcharts.com/highcharts.js"></script>
	<script src="https://code.highcharts.com/modules/series-label.js"></script>
	<script src="https://code.highcharts.com/modules/boost.js"></script>
	<script src="https://code.highcharts.com/modules/data.js"></script>
	<script src="https://code.highcharts.com/modules/exporting.js"></script>
	<script src="https://code.highcharts.com/modules/accessibility.js"></script>
	<script src="https://code.highcharts.com/modules/drag-panes.js"></script>
 -->
<script src="resources/js/moment.js"></script>
<script src="resources/js/FileSaver.min.js"></script>
<script src="resources/js/sheetJS/xlsx.full.min.js"></script>
<script src="resources/js/sheetJS/xlsx.bundle.js"></script>
<style>
input[name='rdo_type'] {
	vertical-align: middle;
	margin-right: 5px;
}

.data-box .data {
	display: flex;
	flex-direction: column;
	width: 100%;
	height: 100%;
	border: 2px solid #233664;
	border-bottom-left-radius: 10px;
	background: #fff;
	border-bottom-right-radius: 10px;
	justify-content: space-around;
	padding: 0 1vw;
}

.data-box .sub-title {
	font-size: 20px;
	font-family: 'Pretendard-SemiBold';
	margin: 2vh;
	margin-bottom: 1vh;
	border-bottom: 2px solid #233664;
	display: flex;
	justify-content: space-between;
}

.data-box .sub-title span {
	display: inline-flex;
	align-items: center;
}

.data-box .data table {
	margin: 2vh;
	margin-top: 0;
	width: unset;
}

.data-box .data table tr td, .data-box .data table tr th {
	height: 3em;
	text-align: center;
	border-bottom: 1px solid #dadae2;
}

.data-box .data table tr td:nth-child(1) {
	width: 20%;
	text-align: left;
	border-right: 1px solid #dadae2;
}

.data-box .data table tr td:nth-child(2) {
	width: 50%;
	text-align: left;
	padding: 0 1em;
	border-right: 1px solid #dadae2;
}

.data-box .data table tr td:nth-child(3) {
	width: 30%;
}

.btn-group {
	display: grid;
	grid-template-columns: repeat(6, 1fr);
	grid-template-rows: repeat(4, 1fr);
	gap: 0.5em;
	margin: 0 auto;
	width: fit-content;
}

.btn-hour, .btn-hour-legend {
	background: #5d6d94;
	color: #fff;
	width: 36px;
	height: 36px;
	font-size: 18px;
	border-radius: 5px;
}

.btn-hour-legend {
	width: 24px;
	height: 24px;
	border-radius: 5px;
	aspect-ratio: 1/1;
}

.btn-hour.lv1, .btn-hour-legend.lv1 {
	background: #83A603;
}

.btn-hour.lv2, .btn-hour-legend.lv2 {
	background: #F29F05;
}

.btn-hour.lv3, .btn-hour-legend.lv3 {
	background: #D95204;
}

.untprc-stts-box {
	display: flex;
	flex-direction: column;
	row-gap: 1em;
	margin: 0 2vw;
}

.txt-box {
	display: flex;
	column-gap: 1em;
	align-items: center;
}

.txt-box p {
	width: 90px;
	display: inline-flex;
	align-items: center;
}

.txt-box input {
	width: 70%;
	text-align: right;
	text-indent: 1em;
}

.txt-box .btn-hour {
	width: 24px;
	height: 24px;
}
</style>
</head>
<body>
	<div id="main" class="main-pss main-contents-grid1"
		style="height: 100%; row-gap: 1em;">
		<div class="main-title"
			style="display: flex; justify-content: space-between;">
			전력량 단가 관리
			<!--<button class='cmmn' onclick="openPwerUsgPrcPop();">사용금액 조회</button>  전력 사용 비용 계산값 팝업 -->
		</div>
		<div class="main-search-group">
			<div class="com-search-unit">
				<p title="단가 설정 조회">조회 년도</p>
				<select id="sel_year" onchange="search();" title="단가 설정 조회">
					<option value="">년도</option>
				</select>
			</div>
			<div class="com-search-unit">
				<p title="저장된 설정을 조회 년도 자료로 불러오기">과거 자료 불러오기</p>
				<select id="sel_bf_year" onchange="getBeforeData();"
					title="저장된 설정을 조회 년도 자료로 불러오기">
					<option value="2024">2024년도</option>
				</select>
				<button class="save" onclick="onSave();"></button>
			</div>
		</div>
		<div>
			<div class="data-box" style="flex-flow: row;">
				<div class="title"
					style="border-top-left-radius: 0.6rem; border-top-right-radius: 0; border-bottom-left-radius: 0.6rem; white-space: nowrap; padding: 0 10px;">
					기준정보</div>
				<div class="data untprc-stts-box"
					style="border-bottom-left-radius: 0; border-top-right-radius: 10px; height: 3.15rem; flex-direction: row; align-items: center; justify-content: space-evenly; margin: 0;">
					<div class="com-search-unit">
						<p title="취수장 요금적용전력">취수장 요금적용전력(kWh)</p>
						<input type="number" id="UNTPRC_I_1" value="0"
							style="text-align: right;">
					</div>
					<div class="com-search-unit">
						<p title="플랜트 요금적용전력">플랜트 요금적용전력(kWh)</p>
						<input type="number" id="UNTPRC_I_2" value="0"
							style="text-align: right;">
					</div>
					<div class="com-search-unit">
						<p title="기본요금(원)">기본요금(원)</p>
						<input type="number" id="UNTPRC_I_3" value="0"
							style="text-align: right;">
					</div>
					<div class="com-search-unit">
						<p title="기후환경요금(원)">기후환경요금(원)</p>
						<input type="number" id="UNTPRC_I_4" value="0"
							style="text-align: right;">
					</div>
					<div class="com-search-unit">
						<p title="연료비조정액(원)">연료비조정액(원)</p>
						<input type="number" id="UNTPRC_I_5" value="0"
							style="text-align: right;">
					</div>
					
				</div>
			</div>
		</div>
		<div class="main-contents-grid2"
			style="column-gap: 4em; height: 100%; padding: 0;">
			<div class="data-box">
				<div class="title">여름 (6~8월)</div>
				<div class="data">
					<div>
						<div class="sub-title">전력량 요금 설정</div>
						<div class="untprc-stts-box">
							<div class='txt-box'>
								<div class="btn-hour-legend lv1"></div>
								<p>경부하</p>
								<input type="number" id="UNTPRC_S_1" value=""><span>(원/kwh)</span>
							</div>
							<div class='txt-box'>
								<div class="btn-hour-legend lv2"></div>
								<p>중간부하</p>
								<input type="number" id="UNTPRC_S_2" value=""><span>(원/kwh)</span>
							</div>
							<div class='txt-box'>
								<div class="btn-hour-legend lv3"></div>
								<p>최대부하</p>
								<input type="number" id="UNTPRC_S_3" value=""><span>(원/kwh)</span>
							</div>
						</div>
					</div>
					<div>
						<div class="sub-title">
							시간대 설정<span>시간 버튼을 클릭하여 설정하세요.</span>
						</div>
						<div class="btn-group" id="BTNGRP_S">
							<button class="btn-hour" title="00:00~01:00">00</button>
							<button class="btn-hour" title="01:00~02:00">01</button>
							<button class="btn-hour">02</button>
							<button class="btn-hour">03</button>
							<button class="btn-hour">04</button>
							<button class="btn-hour">05</button>
							<button class="btn-hour">06</button>
							<button class="btn-hour">07</button>
							<button class="btn-hour">08</button>
							<button class="btn-hour">09</button>
							<button class="btn-hour">10</button>
							<button class="btn-hour">11</button>
							<button class="btn-hour">12</button>
							<button class="btn-hour">13</button>
							<button class="btn-hour">14</button>
							<button class="btn-hour">15</button>
							<button class="btn-hour">16</button>
							<button class="btn-hour">17</button>
							<button class="btn-hour">18</button>
							<button class="btn-hour">19</button>
							<button class="btn-hour">20</button>
							<button class="btn-hour">21</button>
							<button class="btn-hour">22</button>
							<button class="btn-hour">23</button>
						</div>
					</div>
					<div>
						<div class="sub-title" style="margin-bottom: 0px;">요약</div>
						<table id="SUMMRY_S">
							<tr>
								<th></th>
								<th>시간대</th>
								<th>전력량 요금(원/kwh)</th>
							</tr>
							<tr>
								<td>경부하</td>
								<td>-</td>
								<td>-</td>
							</tr>
							<tr>
								<td>중간부하</td>
								<td>-</td>
								<td>-</td>
							</tr>
							<tr>
								<td>최대부하</td>
								<td>-</td>
								<td>-</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
			<div class="data-box">
				<div class="title">봄/가을 (3~5, 9~10월)</div>
				<div class="data">
					<div>
						<div class="sub-title">전력량 요금 설정</div>
						<div class="untprc-stts-box">
							<div class='txt-box'>
								<div class="btn-hour-legend lv1"></div>
								<p>경부하</p>
								<input type="number" id="UNTPRC_F_1" value=""><span>(원/kwh)</span>
							</div>
							<div class='txt-box'>
								<div class="btn-hour-legend lv2"></div>
								<p>중간부하</p>
								<input type="number" id="UNTPRC_F_2" value=""><span>(원/kwh)</span>
							</div>
							<div class='txt-box'>
								<div class="btn-hour-legend lv3"></div>
								<p>최대부하</p>
								<input type="number" id="UNTPRC_F_3" value=""><span>(원/kwh)</span>
							</div>
						</div>
					</div>
					<div>
						<div class="sub-title">
							시간대 설정<span>시간 버튼을 클릭하여 설정하세요.</span>
						</div>
						<div class="btn-group" id="BTNGRP_F">
							<button class="btn-hour" title="00:00~01:00">00</button>
							<button class="btn-hour" title="01:00~02:00">01</button>
							<button class="btn-hour">02</button>
							<button class="btn-hour">03</button>
							<button class="btn-hour">04</button>
							<button class="btn-hour">05</button>
							<button class="btn-hour">06</button>
							<button class="btn-hour">07</button>
							<button class="btn-hour">08</button>
							<button class="btn-hour">09</button>
							<button class="btn-hour">10</button>
							<button class="btn-hour">11</button>
							<button class="btn-hour">12</button>
							<button class="btn-hour">13</button>
							<button class="btn-hour">14</button>
							<button class="btn-hour">15</button>
							<button class="btn-hour">16</button>
							<button class="btn-hour">17</button>
							<button class="btn-hour">18</button>
							<button class="btn-hour">19</button>
							<button class="btn-hour">20</button>
							<button class="btn-hour">21</button>
							<button class="btn-hour">22</button>
							<button class="btn-hour">23</button>
						</div>
					</div>
					<div>
						<div class="sub-title" style="margin-bottom: 0px;">요약</div>
						<table id="SUMMRY_F">
							<tr>
								<th></th>
								<th>시간대</th>
								<th>전력량 요금(원/kwh)</th>
							</tr>
							<tr>
								<td>경부하</td>
								<td>-</td>
								<td>-</td>
							</tr>
							<tr>
								<td>중간부하</td>
								<td>-</td>
								<td>-</td>
							</tr>
							<tr>
								<td>최대부하</td>
								<td>-</td>
								<td>-</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
			<div class="data-box">
				<div class="title">겨울 (11~2월)</div>
				<div class="data">
					<div>
						<div class="sub-title">전력량 요금 설정</div>
						<div class="untprc-stts-box">
							<div class='txt-box'>
								<div class="btn-hour-legend lv1"></div>
								<p>경부하</p>
								<input type="number" id="UNTPRC_W_1" value=""><span>(원/kwh)</span>
							</div>
							<div class='txt-box'>
								<div class="btn-hour-legend lv2"></div>
								<p>중간부하</p>
								<input type="number" id="UNTPRC_W_2" value=""><span>(원/kwh)</span>
							</div>
							<div class='txt-box'>
								<div class="btn-hour-legend lv3"></div>
								<p>최대부하</p>
								<input type="number" id="UNTPRC_W_3" value=""><span>(원/kwh)</span>
							</div>
						</div>
					</div>
					<div>
						<div class="sub-title">
							시간대 설정<span>시간 버튼을 클릭하여 설정하세요.</span>
						</div>
						<div class="btn-group" id="BTNGRP_W">
							<button class="btn-hour" title="00:00~01:00">00</button>
							<button class="btn-hour" title="01:00~02:00">01</button>
							<button class="btn-hour">02</button>
							<button class="btn-hour">03</button>
							<button class="btn-hour">04</button>
							<button class="btn-hour">05</button>
							<button class="btn-hour">06</button>
							<button class="btn-hour">07</button>
							<button class="btn-hour">08</button>
							<button class="btn-hour">09</button>
							<button class="btn-hour">10</button>
							<button class="btn-hour">11</button>
							<button class="btn-hour">12</button>
							<button class="btn-hour">13</button>
							<button class="btn-hour">14</button>
							<button class="btn-hour">15</button>
							<button class="btn-hour">16</button>
							<button class="btn-hour">17</button>
							<button class="btn-hour">18</button>
							<button class="btn-hour">19</button>
							<button class="btn-hour">20</button>
							<button class="btn-hour">21</button>
							<button class="btn-hour">22</button>
							<button class="btn-hour">23</button>
						</div>
					</div>
					<div>
						<div class="sub-title" style="margin-bottom: 0px;">요약</div>
						<table id="SUMMRY_W">
							<tr>
								<th></th>
								<th>시간대</th>
								<th>전력량 요금(원/kwh)</th>
							</tr>
							<tr>
								<td>경부하</td>
								<td>-</td>
								<td>-</td>
							</tr>
							<tr>
								<td>중간부하</td>
								<td>-</td>
								<td>-</td>
							</tr>
							<tr>
								<td>최대부하</td>
								<td>-</td>
								<td>-</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="pwerUsgPrcGridDlg">
		<div class="main-contents-grid1">
			<div class="main-search-group">
				<div class="com-search-unit">
					<button class="save" onclick="ExportExcel();"></button>
				</div>
			</div>
			<div class="main-contents-grid1">
				<div id="grid"></div>
			</div>
		</div>
	</div>
	<div id="pwerUsgPrcDlg">
		<div class="main-contents-grid1">
			<div class="main-search-group">
				<div class="com-search-unit">
					<select id="sel_pwerusgprc_year_from" style="min-width: 80px;">
						<option value="2021">2021년</option>
						<option value="2022">2022년</option>
						<option value="2023">2023년</option>
						<option value="2024">2024년</option>
					</select> <select id="sel_pwerusgprc_mon_from" style="min-width: 80px;">
						<option value="01">01월</option>
						<option value="02">02월</option>
						<option value="03">03월</option>
						<option value="04">04월</option>
						<option value="05">05월</option>
						<option value="06">06월</option>
						<option value="07">07월</option>
						<option value="08">08월</option>
						<option value="09">09월</option>
						<option value="10">10월</option>
						<option value="11">11월</option>
						<option value="12">12월</option>
					</select> ~ <select id="sel_pwerusgprc_year_to" style="min-width: 80px;">
						<option value="2021">2021년</option>
						<option value="2022">2022년</option>
						<option value="2023">2023년</option>
						<option value="2024" selected>2024년</option>
					</select> <select id="sel_pwerusgprc_mon_to" style="min-width: 80px;">
						<option value="01">01월</option>
						<option value="02">02월</option>
						<option value="03">03월</option>
						<option value="04">04월</option>
						<option value="05">05월</option>
						<option value="06">06월</option>
						<option value="07">07월</option>
						<option value="08">08월</option>
						<option value="09">09월</option>
						<option value="10">10월</option>
						<option value="11">11월</option>
						<option value="12">12월</option>
					</select>
					<button class="find" onclick="getChartData();"></button>
				</div>
			</div>
			<div class="main-contents-grid1">
				<select id="sel_pwerusgprc_type" onchange="onChngPwerAmntType();">
					<option value="year">년도별</option>
					<option value="mon">월별</option>
					<option value="day">일별</option>
					<option value="hour">시간별</option>
				</select>
				<div id="chart"></div>
			</div>
		</div>
	</div>
	<script>
		let ptm_list = ["S", "F", "W"];

		// 처음 페이지 로드시
		window.onload = async function() {
			// 조회 년도 초기 설정
			let cur_year = new Date().getFullYear();
			setYearOptions(cur_year);

			search();
		}

		// 조회 년도 select box 만들기
		function setYearOptions(selectedYear) {
		    let from_year = Number(selectedYear) - 5;
		    let to_year = Number(selectedYear) + 5;

		    $("#sel_year option").remove();  // 기존 옵션 삭제

		    for (let year = from_year; year <= to_year; year++) {
		        $("#sel_year").append("<option value=" + year + ">" + year + "년</option>");
		    }

		    // 선택한 연도를 기본값으로 설정
		    $("#sel_year").val(selectedYear);
		}

		function getBeforeUntPrcInfo(){
			return new Promise((resolve, reject)=>{
				
				$.ajax ({
					type: 'POST',
					contentType: 'application/json; charset=utf-8',
					cache : false ,
					url: 'getBeforeUntPrcInfo',
					data: JSON.stringify({}),
					success: function(data) {
						//console.log(data);
						$("#sel_bf_year option").remove();
						for(let d of data){
							$("#sel_bf_year").append("<option value="+d.CRTR_YR+">"+d.CRTR_YR+"년</option>")
						}
						
						$("#sel_bf_year option:last").prop("selected", true);
						
						$("#sel_bf_year").attr("disabled", false);	
						
						resolve();
					},
					error: function(e){
						reject();
					}
				});
			});
			
		}

		async function search() {
			let year = $("#sel_year option:selected").val();

		  	// 선택한 년도를 기준으로 다시 셀렉트 박스 구성
		    setYearOptions(year);

			await getBeforeUntPrcInfo(); // 과거자료 있는 년도 조회

			// 저장된 값 불러오기
			let cnt1 = await getUntPrc(year); // 전력량 요금 설정
			let cnt2 = await getPwrerUntMng(year); // 시간대 설정

			if(cnt1 > 0 || cnt2 > 0){
				$("#sel_bf_year").attr("disabled", true);
			}
			makeSummryTbl(); // 요약
		}

		async function getBeforeData(){

			let year = $("#sel_bf_year option:selected").val();
			// 저장된 값 불러오기
			await getUntPrc(year); // 전력량 요금 설정
			await getPwrerUntMng(year); // 시간대 설정
			
			makeSummryTbl(); // 요약
		}
		
		function getUntPrc(year){
			
			return new Promise((resolve, reject)=>{
				// input box 초기화
				let inputs = document.querySelectorAll(".untprc-stts-box input");
				inputs.forEach((t)=>{
					t.value = "";
				});
				
				$.ajax ({
					type: 'POST',
					contentType: 'application/json; charset=utf-8',
					cache : false ,
					url: 'getPwrerUntPrcMst',
					data: JSON.stringify({year: year}),
					success: function(data) {
						for(let obj of data){
							$("#UNTPRC_"+obj.APLCN_PTM_CD+"_"+obj.DATA_SE_CD).val(obj.APLCN_UNTPRC);
						}
						
						
						resolve(data.length);
					},
					error: function(e){
						reject();
					}
				});
			});
			
		}
		
		function getPwrerUntMng(year){
			
			return new Promise((resolve, reject)=>{
				let allbtns = document.querySelectorAll(".btn-hour");
				allbtns.forEach((t)=>{
					t.classList.remove('lv1');
					t.classList.remove('lv2');
					t.classList.remove('lv3');
				});
				
				$.ajax ({
					type: 'POST',
					contentType: 'application/json; charset=utf-8',
					cache : false ,
					url: 'getPwrerUntMng',
					data: JSON.stringify({year: year}),
					success: function(res) {
						for(let r of res){
							let btns = document.querySelectorAll("#BTNGRP_"+r.APLCN_PTM_CD+" .btn-hour");
							btns.forEach((t)=>{
								let hour = t.innerHTML;
								let lv = r["DATA_SE_CD_"+hour];
								if(lv != "0"){
									t.classList.add('lv'+r["DATA_SE_CD_"+hour]);								
								}
							});
						}
						
						resolve(res.length);
					},
					error: function(e){
						reject();
					}
				});
			});	
		}
		
		function makeSummryTbl(){
			// 요약 테이블 그리기
			for(let key of ptm_list){
				
				let hours_txt = makeTextHour(key);
				
				
				$("#SUMMRY_"+key+" tr").remove();
				
				let tbl = '<tr><th></th><th>시간대</th><th>전력량 요금(원/kwh)</th></tr>'
							+'<tr><td>경부하</td><td>'+hours_txt.lv1.text+'</td><td>'+$("#UNTPRC_"+key+"_1").val()+'</td></tr>'
							+'<tr><td>중간부하</td><td>'+hours_txt.lv2.text+'</td><td>'+$("#UNTPRC_"+key+"_2").val()+'</td></tr>'
							+'<tr><td>최대부하</td><td>'+hours_txt.lv3.text+'</td><td>'+$("#UNTPRC_"+key+"_3").val()+'</td></tr>'
							;
				
				
				$("#SUMMRY_"+key).append(tbl);
			}
			
			
			function makeTextHour(key){
				// 요약 테이블의 시간대 텍스트 만들기
				// key : 여름(S), 봄/가을(F), 겨울(W)
				let result = {
						"lv1": {text: ""},	
						"lv2": {text: ""},	
						"lv3": {text: ""},	
					};
				
				for(let level in result){
					let btns = document.querySelectorAll("#BTNGRP_"+key+" .btn-hour."+level);
					let res = new Array();
					let cnt = 0;
					let rg_cnt = 1;
					
					btns.forEach((t)=>{
						if(res[cnt] == undefined){res[cnt] = {from: null, to: null, from_hour: "", to_hour: ""}};
						let hour = Number(t.innerHTML); // 시간 (ex 01, 02..)
						
						if(res[cnt].from == null){ // 부하의 시작지점이면
							res[cnt].from = hour;
							res[cnt].from_hour = t.innerHTML + ":00";
						}else{
							if(res[cnt].from + rg_cnt == hour){
								res[cnt].to = hour + 1;
								res[cnt].to_hour = (hour + 1).toString().padStart(2, "0") + ":00 ";
								rg_cnt++;
							}else{
								cnt++;
								rg_cnt = 1;
								
								res[cnt] = {from: hour, to: null, from_hour: t.innerHTML + ":00", to_hour: ""}
							}	
						}
					});
					
					if(res.length > 1){ // 23시~다음날 넘어가는 구간 처리
						if(res[res.length-1].from == 23 && res[res.length-1].to == null){
							// 23시만 혼자 칠해져있는 경우 to를 24시로 셋팅
							res[res.length-1].to = 24;
						}
						if(res[0].from == 0 && res[0].to == null){
							// 00시만 혼자 칠해져있는 경우
							res[0].to = res[0].from + 1;
							res[0].to_hour = ( res[0].from + 1).toString().padStart(2, "0") + ":00 ";	
						}
						
						if(res[0].from == 0 && res[res.length-1].to == 24){
							// 00시랑 24시 부분 함치고 24시 빼기
							res[0].from = res[res.length-1].from;
							res[0].from_hour = res[res.length-1].from_hour;
							
							res.pop();
						}
					}
					
					for(let i = 0; i < res.length; i++){
						if(res[i].to == null){res[i].to_hour = (res[i].from + 1).toString().padStart(2, "0") + ":00 ";}
						if(res[i].to == 24){res[i].to_hour = (0).toString().padStart(2, "0") + ":00 ";}
						result[level].text += (res[i].from_hour + " ~ " + res[i].to_hour + " ");
					}
				}
				
				
				return result;
		
			}
			
		}
		
		function onSave(){
			let year = $("#sel_year option:selected").val();
			let data = new Object();
			// 전력량 요금 설정 저장
			data.untprc_list =  new Array();
			
			let inputs = document.querySelectorAll(".untprc-stts-box input");
			inputs.forEach((t)=>{
				let arr = (t.id).split("_");
				data.untprc_list.push({crtr_yr: year, data_cd: '1', aplcn_ptm_cd: arr[1], data_se_cd: arr[2], aplcn_untprc: Number(t.value)});
			});
			
			
			//시간대 설정 저장
			data.hourlist =  new Array();
			for(let key of ptm_list){
				let btns = document.querySelectorAll("#BTNGRP_"+key+" .btn-hour");
				let obj = {crtr_yr: year, aplcn_ptm_cd: key};
				btns.forEach((t)=>{
					let hour = t.innerHTML;
					
					if(t.classList.contains("lv1")){
						obj["hr_" + hour] = '1';	
					}else if(t.classList.contains("lv2")){
						obj["hr_" + hour] = '2';
					}else if(t.classList.contains("lv3")){
						obj["hr_" + hour] = '3';
					}else{
						obj["hr_" + hour] = '0';
					}
				});
				
				data.hourlist.push(obj);
			}
			
			$.ajax ({
				type: 'POST',
				contentType: 'application/json; charset=utf-8',
				cache : false ,
				url: 'onSaveUntPrcAndHour',
				data: JSON.stringify(data),
				success: function(res) {
					alert(year+"년 전력량 단가 설정이 저장되었습니다.");
					search();
				}
			});
		
		}
		
		// 시간대 설정 버튼 클릭 이벤트
		document.querySelectorAll('.btn-hour').forEach((v, i)=>{
			v.addEventListener("click", function(e){
				if(e.target.classList.contains('lv1')){
					e.target.classList.remove('lv1');
					e.target.classList.add('lv2');
				}else if(e.target.classList.contains('lv2')){
					e.target.classList.remove('lv2');
					e.target.classList.add('lv3');
				}else if(e.target.classList.contains('lv3')){
					e.target.classList.remove('lv3');
				}else{
					e.target.classList.add('lv1');					
				}
				
				makeSummryTbl((e.target.parentElement.id).split("_")[1]);
			});
		});
		
		
		
		// -------------------------------------------------------------------------------------------------------------------------------
		// 전력 사용 비용 팝업
		
		$("#pwerUsgPrcDlg").dialog({
			autoOpen: false,
			resizable:false,
			closeOnEscape: false,
			width: "70vw",
			open: function(args){
				
			},
			buttons: {
				"닫기": function() {
					$(this).dialog("close");
				},
				
			}
	    });
		
		
		function openPwerUsgPrcPop(){
			// 기타 설정
			$(".ui-widget-header").addClass("title-style");
			$(".ui-dialog-titlebar-close").remove();
			
			initChart();
			
			
			
			// 다이얼로그 열기 및 타이틀 설정
			$("#pwerUsgPrcDlg").dialog("option", "title", "소비전력 사용 금액 조회").dialog("open");
		}
		
		let gChart = null;
		function initChart(){
			
			if(gChart != null){
				gChart.destroy();
				gChart = null;
			}
			
			Highcharts.setOptions({
			    lang: {
			    	thousandsSep: ",",
			    	months: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
			        weekdays: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
			        shortMonths: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월']
			    }
			});
		
			gChart = Highcharts.chart('chart', {
				chart: {zoomType: 'x'},
			    title: {text: ''},
			    subtitle: {text: '',},
			    yAxis: {
			        title: {
			            text: '원'
			        }
			    },
			    xAxis: {
			        type: 'datetime',
			        dateTimeLabelFormats: {
			        	day: '%Y년 %m월 %d일', // 일 단위 레이블 형식
			            hour: '%H시',
			            month: '%Y년 %m월',
			            year: '%Y년'
			        },
			        labels: {
			        	autoRotation: [0],
			        	overflow: 'allowOverlap',
			        }
			    },
			    tooltip: {
			    	valueDecimals: 2,
			        valueSuffix: ' 원',
			        shared: true,
			        formatter: function(){
			        	
			        	let sel_type = this.series.userOptions.sel_type;
			        	
			        	let prc = Math.round(this.y * 100)/100;
			        	if(isNaN(prc)){ 
			        		prc = '-';
			        	}else{
				        	prc = prc.toLocaleString(undefined, { minimumFractionDigits: 2 });			        		
			        	}
			        	
			        	
			        	let info = new Object();
			        	let date_label = "";
			        	let usg = 0; // 사용량
			        	if(sel_type == "year"){
			        		let year = new Date(this.x).format("yyyy");
			        		
			        		if(!!chartData[sel_type][year]){
				        		date_label = chartData[sel_type][year].label;
				        		usg = (chartData[sel_type][year].amount).toLocaleString(undefined, { minimumFractionDigits: 2});		        			
			        		}else{
			        			date_label = year + "년";
			        			usg = "-";
			        		}
			        		
			        		return '<b>' + date_label + '</b><br/>' +
		        			'<span>사용 금액 : ' + prc + ' 원</span><br/>' +
		        			'<span>(사용량: '+ usg +' kw)</span>';
			        		
			        	}else if(sel_type == "mon"){
							let date = new Date(this.x).format("yyyyMM");
			        		
			        		if(!!chartData[sel_type][date]){
				        		date_label = chartData[sel_type][date].label;
				        		usg = (chartData[sel_type][date].amount).toLocaleString(undefined, { minimumFractionDigits: 2});        			
			        		}else{
			        			date_label = new Date(this.x).format("yyyy년 MM월");
			        			usg = "-";
			        		}
			        		
			        		return '<b>' + date_label + '</b><br/>' +
		        			'<span>사용 금액 : ' + prc + ' 원</span><br/>' +
		        			'<span>(사용량: '+ usg +' kw)</span>';
			        	}else if(sel_type == "day"){
							let date = new Date(this.x).format("yyyyMMdd");
			        		
			        		if(!!chartData[sel_type][date]){
				        		date_label = chartData[sel_type][date].label;
				        		usg = (chartData[sel_type][date].amount).toLocaleString(undefined, { minimumFractionDigits: 2});        			
			        		}else{
			        			date_label = new Date(this.x).format("yyyy년 MM월 dd일");
			        			usg = "-";
			        		}
			        		
			        		return '<b>' + date_label + '</b><br/>' +
		        			'<span>사용 금액 : ' + prc + ' 원</span><br/>' +
		        			'<span>(사용량: '+ usg +' kw)</span>';
			        	}else if(sel_type == "hour"){
			        		
							let date = moment(this.x).utc().format("YYYYMMDDHH");
							let untprc = "-";
							
			        		if(!!chartData[sel_type][date]){
				        		date_label = chartData[sel_type][date].label;
				        		usg = (chartData[sel_type][date].amount).toLocaleString(undefined, { minimumFractionDigits: 2});     
				        		untprc = (chartData[sel_type][date].untprc).toLocaleString(undefined, { minimumFractionDigits: 2});			     
			        		}else{
			        			date_label = moment(this.x).utc().format("YYYY년 MM월 DD일 HH시");
			        			usg = "-";
			        		}
			        		
				        	return '<b>' + date_label + '</b><br/>' +
		        			'<span>사용 금액 : ' + prc + ' 원</span><br/>' +
		        			'<span>(사용량: '+ usg +' kw, 단가: '+ untprc +'원)</span>';
		        			
			        	}
			        	
			        	
			        	
			        }
			    },
			    legend: {
			    	enabled: false
                },
			    plotOptions: {
			        series: {
			            label: {
			                connectorAllowed: false
			            },
			        }
			    },
			    exporting: {
			        buttons: {
			            contextButton: {
			            	menuItems: [
			                    'downloadPNG', 
			                    'separator', 
			                    {
			                        text: '데이터 보기', // 사용자 정의 버튼 텍스트
			                        onclick: openPopGrid // 클릭 시 호출할 함수
			                    }
			                ]
			            }
			        }
			    },
			    series: [],
			});
			getChartData();
			
		}
		
		let chartData = null;
		function getChartData(){
			
			let p = new Promise((resolve, reject)=>{ 
				let data = {
						from_year: $("#sel_pwerusgprc_year_from option:selected").val(),
						from_mon: $("#sel_pwerusgprc_mon_from option:selected").val(),
						to_year: $("#sel_pwerusgprc_year_to option:selected").val(),
						to_mon: $("#sel_pwerusgprc_mon_to option:selected").val(),
				}
				$.ajax ({
					type: 'POST',
					contentType: 'application/json; charset=utf-8',
					cache : false ,
					url: 'getUsgPrcValues',
					data: JSON.stringify(data),
					success: function(res) {
						chartData = {year: new Object(), mon: new Object(), day: new Object(), hour: new Object()};
						for(let data of res){
							let yyyy = data.YYYY;
							let mm = data.MM;
							let dd = data.DD;
							let hh = data.HH;
							
							// 년도별
							if(!!!chartData["year"][yyyy]){
								chartData["year"][yyyy] = {label: yyyy + '년', datetime: Date.UTC(yyyy, 0, 1), price: 0, amount: 0};
							}
							
							chartData["year"][yyyy]["price"] += data.TOT_PRC;
							chartData["year"][yyyy]["amount"] += data.LAST_VALUE;
							
							// 월별
							let mon = yyyy+mm;
							if(!!!chartData["mon"][mon]){
								chartData["mon"][mon] = {label: `\${yyyy}년 \${mm}월`, datetime: Date.UTC(yyyy, mm-1, 1), price: 0, amount: 0};
							}
							
							chartData["mon"][mon]["price"] += data.TOT_PRC;
							chartData["mon"][mon]["amount"] += data.LAST_VALUE;
							
							
							// 일별
							let day = yyyy + mm + dd;
							if(!!!chartData["day"][day]){
								chartData["day"][day] = {label: `\${yyyy}년 \${mm}월 \${dd}일`, datetime: Date.UTC(yyyy, mm-1, dd), price: 0, amount: 0};
							}
							
							chartData["day"][day]["price"] += data.TOT_PRC;
							chartData["day"][day]["amount"] += data.LAST_VALUE;
							
							// 시간별
							let hour = yyyy + mm + dd + hh;
							chartData["hour"][hour] = {
								label: `\${yyyy}년 \${mm}월 \${dd}일 \${hh}시`,
								datetime: Date.UTC(yyyy, mm-1, dd, hh, 0, 0),
								price: data.TOT_PRC,
								amount: data.LAST_VALUE,
								untprc: data.APLCN_UNTPRC
							};
							
						}
						resolve();
					},
					error: function(x){
						console.log("get chart data error")
						reject();
					}
				});
			});
			
			p.then(()=>{
				drawChart();				
			});
			
		}
		
		function onChngPwerAmntType(){

			// 로딩 표시 시작
			gChart.showLoading('데이터를 로드하는 중입니다...');
			setTimeout(function(){
				drawChart();
			},1);
			
		}
		function drawChart(){
			let sel_type = $("#sel_pwerusgprc_type option:selected").val();
			
			let typeData = chartData[sel_type];
			
			let category = new Array();
			let series = {
			        name: '',
			        sel_type: sel_type,
			        data: new Array(),
			        lineWidth: 0.5,
			    }
			
			let data = new Array();
			
			if(sel_type == "year"){
				let from = Number($("#sel_pwerusgprc_year_from option:selected").val());
				let to = Number($("#sel_pwerusgprc_year_to option:selected").val());
				
				for(let i = from; i <= to; i++){
					//category.push(i+"년");
					if(!!!typeData[i]){
						data.push([Date.UTC(i, 1, 1), 0]);
					}else{
						data.push([typeData[i].datetime, typeData[i].price]);						
						//data.push({y: (typeData[i].price || null), z: (typeData[i].amount || null)});						
					}
				}
				
			}else if(sel_type == "mon"){
				let from_year = $("#sel_pwerusgprc_year_from option:selected").val();
				let from_mon = $("#sel_pwerusgprc_mon_from option:selected").val();
				let to_year = $("#sel_pwerusgprc_year_to option:selected").val();
				let to_mon = $("#sel_pwerusgprc_mon_to option:selected").val();
				
				let from = moment(from_year + "-" + from_mon + "-01").format("YYYY-MM-DD");
				let to = moment(to_year + "-" + to_mon + "-01").add(1, 'month').format("YYYY-MM-DD");
				
				while(from <= to){
					
					//category.push(moment(from).format("YYYY년 MM월"));
					
					let key = moment(from).format("YYYYMM");
					if(!!!typeData[key]){
						data.push([Date.UTC(moment(from).format("YYYY"), moment(from).format("MM")-1, 1), null]);
					//	data.push({y: null, z: null});
					}else{
						data.push([typeData[key].datetime, typeData[key].price]);	
						//data.push({y: (typeData[key].price || null), z: (typeData[key].amount || null)});						
					}
					from = moment(from).add(1, 'month').format("YYYY-MM-DD");
				}
				
		
				//tick = Math.ceil(data.length / 12);
				//gChart.xAxis[0].options.tickInterval = tick;
			}else if(sel_type == "day"){
				let from_year = $("#sel_pwerusgprc_year_from option:selected").val();
				let from_mon = $("#sel_pwerusgprc_mon_from option:selected").val();
				let to_year = $("#sel_pwerusgprc_year_to option:selected").val();
				let to_mon = $("#sel_pwerusgprc_mon_to option:selected").val();
				
				let from = moment(from_year + "-" + from_mon + "-01").format("YYYY-MM-DD");
				let to = moment(to_year + "-" + to_mon + "-01").add(1, 'month').format("YYYY-MM-DD");
				
				while(from <= to){
					
					//category.push(moment(from).format("YYYY년 MM월 DD일"));
					
					let key = moment(from).format("YYYYMMDD");
					
					if(key == "20230101"){
						console.log(key);
					}
					if(!!!typeData[key]){
						data.push([Date.UTC(moment(from).format("YYYY"), moment(from).format("MM")-1, moment(from).format("DD")), null]);
						//data.push({y: null, z: null});
					}else{
						data.push([typeData[key].datetime, typeData[key].price]);
						//data.push({y: (typeData[key].price || null), z: (typeData[key].amount || null)});						
					}
					from = moment(from).add(1, 'day').format("YYYY-MM-DD");
				}
				
				//tick = Math.ceil(data.length / 4);
				//gChart.xAxis[0].options.tickInterval = tick;
			}else{ // hour
				let from_year = $("#sel_pwerusgprc_year_from option:selected").val();
				let from_mon = $("#sel_pwerusgprc_mon_from option:selected").val();
				let to_year = $("#sel_pwerusgprc_year_to option:selected").val();
				let to_mon = $("#sel_pwerusgprc_mon_to option:selected").val();
				
				let from = moment(from_year + "-" + from_mon + "-01 00:00:00").format("YYYY-MM-DD 00:00:00");
				let to = moment(to_year + "-" + to_mon + "-01 00:00:00").add(1, 'month').format("YYYY-MM-DD 00:00:00");
				
				while(from <= to){
					
					//category.push(moment(from).format("YYYY년 MM월 DD일 HH시"));
					
					let key = moment(from).format("YYYYMMDDHH");
					if(!!!typeData[key]){
						let date = Date.UTC(moment(from).format("YYYY"), moment(from).format("MM")-1, moment(from).format("DD"), moment(from).format("HH"), 0, 0);
						data.push([date, null]);
						//data.push({y: null, z: null});
					}else{
						data.push([typeData[key].datetime, typeData[key].price]);
						//data.push({y: (typeData[key].price || null), z: (typeData[key].amount || null), up:  (typeData[key].untprc || null)});						
					}
					from = moment(from).add(1, 'hour').format("YYYY-MM-DD HH:00:00");
				}
				
			}
			
			series.data = data;
			
			for(let i = gChart.series.length - 1; i >= 0 ; i--){
				gChart.series[i].remove();
			}
		//	gChart.xAxis[0].categories = [];
			
	//		gChart.xAxis[0].setCategories(category);
			gChart.addSeries(series);
			//
			gChart.redraw();
			/*
			gChart.xAxis[0].update({
		        tickInterval: tick,
		        tickAmount: 5
		    });
			*/
			
			gChart.hideLoading();
			
		}
		
		$("#pwerUsgPrcGridDlg").dialog({
			autoOpen: false,
			resizable: true,
			closeOnEscape: false,
			width: "50vw",
			open: function() {
		        // 팝업이 열릴 때 그리드 높이를 동적으로 설정
		        $("#grid").jsGrid("option", "height", "50vh"); // 다이얼로그 높이에 맞추기
		        
		    },
			buttons: {
				"닫기": function() {
					$(this).dialog("close");
				},
				
			}
	    });
		

		$("#grid").jsGrid({
			width : "99%",
			height : "550px",
			sorting : true,
			paging: true,
   		    pageSize: 1000,
   		 	pageButtonCount : 5,
			data: [],
			fields : []
		});
		
		function openPopGrid(){
			// 기타 설정
			$(".ui-widget-header").addClass("title-style");
			$(".ui-dialog-titlebar-close").remove();
			
			initGrid();
			// 다이얼로그 열기 및 타이틀 설정
			$("#pwerUsgPrcGridDlg").dialog("option", "title", "소비전력 사용 금액 조회").dialog("open");
		}
		
		function initGrid(){
			let fields = [ 
				{ name: "date", type: "number", width: 120, title: "일자",  align: "center"},
				{ name: "price", type: "text", width: 150, title: "사용금액",  align: "center", 
					itemTemplate: function(value, row){
						let result = (Math.round(value * 100) / 100).toLocaleString(undefined, { minimumFractionDigits: 2})
						return (result || "-");
					}
				},
				{ name: "amount", type: "text", width: 150, title: "사용량",  align: "center", 
					itemTemplate: function(value, row){
						let result = (Math.round(value * 100) / 100).toLocaleString(undefined, { minimumFractionDigits: 2})
						return (result || "-");
					}
				},
	       	]
			let data = new Array();
			let xData = gChart.series[0].xData;
			let yData = gChart.series[0].yData;
			
			let key_time_format = "";
			let display_time_format = "";
			let sel_type = $("#sel_pwerusgprc_type option:selected").val();
			if(sel_type == "year"){
				key_time_format = "YYYY";
				display_time_format = "YYYY년";
			}else if(sel_type == "mon"){
				key_time_format = "YYYYMM";
				display_time_format = "YYYY년 MM월";
			}else if(sel_type == "day"){
				key_time_format = "YYYYMMDD";
				display_time_format = "YYYY년 MM월 DD일";
			}else if(sel_type == "hour"){
				key_time_format = "YYYYMMDDHH";
				display_time_format = "YYYY년 MM월 DD일 HH시";
				fields.push({ name: "untprc", type: "text", width: 150, title: "단가",  align: "center", 
					itemTemplate: function(value, row){
						let result = (Math.round(value * 100) / 100).toLocaleString(undefined, { minimumFractionDigits: 2})
						return (result || "-");
					}
				});
			}
			
			for(let idx in yData){
				let x = xData[idx]; // time
				let y = yData[idx]; // value
				let time = moment(x).utc().format(key_time_format);
				let obj = chartData[sel_type][time];
				
				if(!!!obj){
					obj = {
						label: moment(x).utc().format(display_time_format),
						amount: null
					}
				}
				data.push({date: obj.label, price: (y || null), amount: obj.amount, untprc: (obj.untprc || null)});
			}
			
			$("#grid").jsGrid("option", "fields", fields);
			$("#grid").jsGrid("option", "data", data);
			
			
		}
	
		function ExportExcel()
		{
			let sel_type = $("#sel_pwerusgprc_type option:selected").val();
			
			let fileName = '소비전력사용금액.xlsx';
			
			var data =  new Array(); 
			var rows = $("#grid").data("JSGrid").data;
			var fields = $("#grid").data("JSGrid").fields;
			
			var header = new Array();
			for(var i = 0; i < fields.length; i++) {
				header.push({v: fields[i].title, t: "s", s: {alignment : {vertical: "center", horizontal: "center"}, fill: { fgColor: {rgb: "F2F2F2"}}, font: {bold: true}}});
			}
			data.push(header);
			
			for(var i = 0; i < rows.length; i++) {
				var row = new Array();
				for(var j = 0; j < fields.length; j++) 	{
					let isString = true;
					var val = String(rows[i][fields[j].name]);
					if(j >= 1) {
						isString = false;
						val = Number(val.replace(/,/gi, ""));
						if(isNaN(val)) {
							isString = true;
							val = "-";
						}
					}
					
					let cell = {v: val};
					if(isString){
						cell.t = "s";
						cell.s = {
							alignment : {vertical: "center", horizontal: "center"}
						};
					}else{
						cell.t = "n";
						cell.s = {
							alignment : {vertical: "center", horizontal: "right"},
						};
						cell.z = '#,##0.00';
					}
					row.push(cell);
				}
				data.push(row);
			}
			
		    var wb = XLSX.utils.book_new();
		    var newWorksheet = XLSX.utils.aoa_to_sheet(data);
		   	newWorksheet["!cols"] = [
		    	{wpx : 120 },
		    	{wpx : 120 },
		    	{wpx : 120 },
		    ];
		    XLSX.utils.book_append_sheet(wb, newWorksheet, 'sheet1');
		    var wbout = XLSX.write(wb, {bookType:'xlsx',  type: 'binary'});
		    saveAs(new Blob([s2ab(wbout)],{type:"application/octet-stream"}), fileName);
		}

		function s2ab(s) { 
		    var buf = new ArrayBuffer(s.length); //convert s to arrayBuffer
		    var view = new Uint8Array(buf);  //create uint8array as viewer
		    for (var i=0; i<s.length; i++) view[i] = s.charCodeAt(i) & 0xFF; //convert to octet
		    return buf;    
		}
	
	</script>
</body>
</html>