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
<title>시설물관리 - 데이터 일괄 보정</title>
<script src="resources/js/moment.js"></script>
<script src="resources/js/tui/tui-grid.js"></script>
<script src="resources/js/highcharts/highcharts.js"></script>
<script src="resources/js/highcharts/highcharts-more.js"></script>
<!-- <script src="resources/js/highcharts/modules/data.js"></script> -->
<script src="resources/js/highcharts/modules/solid-gauge.js"></script>
<script src="resources/js/highcharts/modules/exporting.js"></script>
<script src="resources/js/highcharts/modules/export-data.js"></script>
<script src="resources/js/highcharts/modules/accessibility.js"></script>
<link rel="stylesheet" href="resources/js/tui/tui-grid.css" />
</head>
<body>
	<div id="main" class="main-screen">
		<div class="main-title">데이터 일괄 보정</div>
		<div class="main-search-group">
			<div class="com-search-unit">
				<p>공정</p>
				<select id="sel_proc" onchange="onChangeProc();"></select>
				<p>조회 일시</p>
				<input type="date" id="strtDate" /> <input type="time"
					id="strtTime" />
				<p>~</p>
				<input type="date" id="endDate" /> <input type="time" id="endTime" />
				<button class="find" onclick="getStatsData();"></button>
			</div>
			<div class="com-search-unit">
				<button class="save disabled" onclick="insertDataQcHsty();"></button>
			</div>
		</div>
		<div class="main-data-group main-contents-grid1"
			style="row-gap: 1.6rem;">
			<div class="main-contents-grid2 contents-grid-top">
				<div id="dataDashLoading" style="display: none;">
					<img src="/resources/images/com/ajax-loader-big.gif" />
				</div>
				<div class="main-contents-grid1 data-dash-container">
					<div class="main-contents-grid2 data-dash-top">
						<div class="data-dash">
							<div class="data-dash-title">총개수</div>
							<div id="totalCount">0</div>
						</div>
						<div class="data-dash-line">
							<svg xmlns="http://www.w3.org/2000/svg" width="100%"
								height="100%" preserveAspectRatio="none">
								<line x1="0" y1="10%" x2="0" y2="90%" stroke="#D5DBF1"
									stroke-width="100%" />
							</svg>
						</div>
						<div class="data-dash">
							<div class="data-dash-title">일치</div>
							<div id="samePercent">0%</div>
						</div>
					</div>
					<div class="main-contents-grid2 data-dash-bottom">
						<div class="data-dash data-dash-l">
							<div class="data-dash-title">Historian</div>
							<div id="hisCount" class="data-dash-count">0</div>
							<div id="hisPercent" class="data-dash-percent">0.0%</div>
						</div>
						<div class="data-dash-icon">
							<svg id="toBizArrow" xmlns="http://www.w3.org/2000/svg"
								width="100%" viewBox="0 0 41 41" fill="none">
								<title>HistorianToBizNexus</title>
								<rect x="0.5" y="0.5" width="40" height="40" rx="7.5"
									fill="#EBF7F5" stroke="#EBF7F5" />
								<path d="M11.75 24H29.25" stroke="#379A82" stroke-width="2.5"
									stroke-linecap="round" stroke-linejoin="round" />
								<path d="M20.5 15.25L29.25 24" stroke="#379A82"
									stroke-width="2.5" stroke-linecap="round"
									stroke-linejoin="round" />
							</svg>
							<svg id="arrowReset" xmlns="http://www.w3.org/2000/svg"
								width="100%" viewBox="0 0 41 41" fill="none"
								onclick="clearData(true);">
								<title>Reset</title>
								<rect width="41" height="41" rx="8" fill="#EEF1FC" />
								<path d="M31.5791 12.54V18.2871H25.832" stroke="#687D9E"
									stroke-width="2.5" stroke-linecap="round"
									stroke-linejoin="round" />
								<path d="M9.91797 28.6026V25.8024V22.8555H15.6651"
									stroke="#687D9E" stroke-width="2.5" stroke-linecap="round"
									stroke-linejoin="round" />
								<path
									d="M12.8378 16.74C13.3236 15.3672 14.1492 14.1398 15.2377 13.1724C16.3261 12.2049 17.6419 11.529 19.0622 11.2077C20.4825 10.8863 21.9611 10.93 23.36 11.3346C24.7589 11.7392 26.0324 12.4916 27.0619 13.5216L31.5063 17.6978M10.4336 23.2976L14.878 27.4738C15.9075 28.5037 17.1811 29.2561 18.5799 29.6608C19.9788 30.0654 21.4574 30.1091 22.8777 29.7877C24.298 29.4663 25.6138 28.7904 26.7022 27.823C27.7907 26.8556 28.6163 25.6282 29.1021 24.2554"
									stroke="#687D9E" stroke-width="2.5" stroke-linecap="round"
									stroke-linejoin="round" />
							</svg>
							<svg id="toHisArrow" xmlns="http://www.w3.org/2000/svg"
								width="100%" viewBox="0 0 41 41" fill="none">
								<title>BizNexusToHistorian</title>
									<rect width="41" height="41" rx="8" fill="#F4F2FF" />
									<path d="M29.25 17H11.75" stroke="#8979E0" stroke-width="2.5"
									stroke-linecap="round" stroke-linejoin="round" />
									<path d="M11.75 17L20.5 25.75" stroke="#8979E0"
									stroke-width="2.5" stroke-linecap="round"
									stroke-linejoin="round" />
							</svg>
						</div>
						<div class="data-dash data-dash-r">
							<div class="data-dash-title">BizNexus</div>
							<div id="bizCount" class="data-dash-count">0</div>
							<div id="bizPercent" class="data-dash-percent">0.0%</div>
						</div>
					</div>
				</div>
				<div id="cntChart" style="width: 32%; height: 99%;"></div>
				<div id="ratioChart" style="width: 25%; height: 99%;"></div>
				<div class="stats-container">
					<div class="stats-container-title">보정 현황</div>
					<div class="stats-container-import">
						<div class="progress-container">
							<div id="importProgressBar" data-percent="100%"></div>
						</div>
					</div>
				</div>
			</div>
			<div class="main-contents-grid2" style="width: 100%; height: 63%;">
				<div class="main-contents-grid1" style="width: 30%;">
					<div class="grd-search-grp" style="height: 8%;">
						<p class="grd-sub-title">태그 목록</p>
						<input type="text" id="input_tag_nm" class="search-ai-input"
							placeholder="태그명 검색" onkeydown="inputKeyDownEvent(this);" /> <input
							type="text" id="input_tag_desc" class="search-ai-input"
							placeholder="태그 설명 검색" onkeydown="inputKeyDownEvent(this);" />
						<button id="btnSearch" class="find" onClick="searchTag();"></button>
					</div>
					<div id="tagList" class="tui-grid-row-select-table"
						style="height: 91%;"></div>
				</div>
				<div class="main-contents-grid2"
					style="width: 69%; justify-content: space-between;">
					<div class="main-contents-grid1" style="width: 48.5%;">
						<div class="grd-search-grp"
							style="height: 8%; justify-content: space-between;">
							<p class="grd-sub-title">
								<span class="historian-text">Historian</span> 데이터
							</p>
						</div>
						<div id="hisDataList" style="height: 91%;"></div>
					</div>
					<div class="main-contents-grid1" style="width: 48.5%;">
						<div class="grd-search-grp"
							style="height: 8%; justify-content: space-between;">
							<p class="grd-sub-title">
								<span class="biznexus-text">BizNexus</span> 데이터
							</p>
						</div>
						<div id="bizDataList" style="height: 91%;"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
	// 처음 페이지 로드시
	window.onload = async function() {
		// 조회기간 설정
		let start = new Date(), end = new Date();
		start.setHours(end.getHours() - 24);
		end.setHours(end.getHours() + 1);

		setDateTime($("#strtDate"), $("#strtTime"), start);
		setDateTime($("#endDate"), $("#endTime"), end);

		// 공정 목록 조회
		await getDataSourceList("sel_dataSource", getDataSourceListLogic);
		await getProcInfoList();
		// 공정별 태그 목록 조회
		onChangeProc();
	};

	const __dataObj = {
		"digits": 1000,
		"tagDataList": [],
		"destDataList": [],
		"tagGrid": null,
		"dataCntChart": null,
		"dataRatioChart": null,
		"dataList": {},
		"dataListOrg": {},
		"hisDataGrid": null,
		"bizDataGrid": null,
		"datasave": null,
		"dbsave": null,
		"previousRowKey": null,
		"previousColumnName": null,
		"scrollEvent": null,
		"arrowEvent": null,
		"resized": false,
		"colorByValue": [
			[0.15, "#DB1640"],
			[0.5, "#F4D451"],
			[0.85, "#659962"]
		],
		/*
		"hisTotalCount": 0,
		"hisDataCount": 0,
		"hisMissCount": 0,
		"hisDataSum": 0,
		"bizTotalCount": 0,
		"bizDataCount": 0,
		"bizMissCount": 0,
		"bizDataSum": 0,
		"sameDataCount": 0,
		*/
		"samePercent": 0,
		"setLoadingMask": function(isShow) {
			$("#loading-mask").data("isShow", isShow);
			if (isShow) {
				$("#loading-mask").show();
			} else {
				$("#loading-mask").fadeOut();
			}
		},
		"getLoadingMask": function() {
			let isShow = $("#loading-mask").data("isShow");
			if (isShow) {
				MsgBox("Info", "이미 조회중입니다.");
			}
			return isShow;
		},
		"setDashLoadingMask": function(isShow) {
			$("#dataDashLoading").data("isShow", isShow);
			if (isShow) {
				$("#dataDashLoading").show();
			} else {
				$("#dataDashLoading").fadeOut();
			}
		},
		"getDashLoadingMask": function(notShowMessage) {
			let isShow = $("#dataDashLoading").data("isShow");
			if (isShow && !notShowMessage) {
				MsgBox("Info", "이미 조회중입니다.");
			}
			return isShow;
		},
		"importStatusInterval": null
	};

	// 공정별 태그 목록 조회
	async function onChangeProc() {
		// 태그 설정
		__dataObj["bizDataGrid"].resetData([]);
		__dataObj["hisDataGrid"].resetData([]);
		__dataObj["tagGrid"].resetData([]);
		/*
		if ($("#input_tag_nm").val() == "*") {
			$("#input_tag_nm").val("");
		}
		if ($("#input_tag_desc").val() == "*") {
			$("#input_tag_desc").val("");
		}
		*/
		let proc_cd = $("#sel_proc option:selected").val();
		getProcTagList(proc_cd); //await getHstnTagList({procs_id: proc_cd});
	};

	function getDataSourceListLogic(data) {
		__dataObj["destDataList"] = data;
		$(".historian-text").text(data.find(obj => obj.CD_NM.toLowerCase().startsWith("his")).CD_NM);
		$(".biznexus-text").text(data.find(obj => obj.CD_NM.toLowerCase().startsWith("biz")).CD_NM);
	}

	function getProcTagList(procs_id) {
		__dataObj.setLoadingMask(true);
		// 공정에 따른 태그 목록 조회
		$.ajax ({
			type: "POST",
			contentType: "application/json; charset=UTF-8",
			url: "getHstnTagList",
			dataType: "json",
			cache: true,
			data: JSON.stringify({procs_id: procs_id}),
			success: function(res) {
				let data = new Array();

				// 태그 리스트 데이터 가공
				for (let tag of res) {
					data.push({
						TAGSN: tag.TAGSN,
						TAG_NM: tag.NODE_NM + "." + tag.TAG_ADDR,
						TAG_DESC: tag.TAG_DESC
					});
				}

				__dataObj["tagDataList"] = data;
				__dataObj.setLoadingMask(false);
				importStatus();
				getStatsData();
			},
			error: function(e) {
				MsgBox("Info", "태그 목록 조회에 실패하였습니다.");
				__dataObj.setLoadingMask(false);
			}
		});
	};

	async function getStatsData() {
		// 전체태그에 대한 차트 조회
		if (__dataObj.getDashLoadingMask()) {
			return;
		}
		let from_dt = moment($("#strtDate").val() + " " + $("#strtTime").val()).format("YYYY-MM-DD HH:mm:ss");
		let to_dt = moment($("#endDate").val() + " " + $("#endTime").val()).format("YYYY-MM-DD HH:mm:ss");

		if ((new Date(to_dt) - new Date(from_dt)) > 7 * 24 * 60 * 60 * 1000) {
			MsgBox("Info", "최대 조회기간은 7일입니다.");
			return;
		}
		__dataObj.setDashLoadingMask(true);

		let obj = new Object();
		obj.cmd = "stats";
		obj.timeout = 3 * 60 * 1000;
		obj.dest = "stats";
		obj.param = {
			"start": from_dt,
			"end": to_dt,
			"tagList": ""
		};

		$.ajax ({
			type: "POST",
			contentType: "application/json; charset=UTF-8",
			url: "reqHistorian",
			dataType: "json",
			cache: true,
			data: JSON.stringify(obj),
			success: function(res) {
				if (res && res["param"] && res["param"].length) {
					let hisObj = res["param"].find(item => item["name"] == "historian");
					let bizObj = res["param"].find(item => item["name"] == "biznexus");

					let hisDataLength = hisObj["dataLength"];
					$("#hisCount").text(new Intl.NumberFormat("ko-KR").format(hisDataLength));

					let bizDataLength = bizObj["dataLength"];
					$("#bizCount").text(new Intl.NumberFormat("ko-KR").format(bizDataLength));

					let hisMissLength = hisObj["missLength"];
					let bizMissLength = bizObj["missLength"];

					createCntChart(hisDataLength, bizDataLength, hisMissLength, bizMissLength);

					let totalLength = hisObj["totalLength"] || bizObj["totalLength"];
					$("#totalCount").text(new Intl.NumberFormat("ko-KR").format(totalLength));

					let hisPercent = Math.round(hisDataLength / totalLength * 100 * 10) / 10;
					$("#hisPercent").text(hisPercent.toFixed(1) + "%");

					let bizPercent = Math.round(bizDataLength / totalLength * 100 * 10) / 10;
					$("#bizPercent").text(bizPercent.toFixed(1) + "%");

					let sameDataLength = hisObj["sameDataLength"] || bizObj["sameDataLength"];
					let notSameDataLength = hisObj["notSameDataLength"] || bizObj["notSameDataLength"];
					__dataObj["samePercent"] = Math.round(sameDataLength / totalLength * 100);
					$("#samePercent").text(__dataObj["samePercent"] + "%");

					/*
					let colorByValue = [[0, __dataObj["colorByValue"][0][1]]];
					for (let idx = 0; idx < __dataObj["colorByValue"].length; idx++) {
						let item = Object.assign([], __dataObj["colorByValue"][idx]);
						if (idx == (Math.round(__dataObj["colorByValue"].length / 2)) - 1) {
							let addItem = Object.assign([], __dataObj["colorByValue"][idx]);
							addItem[0] = addItem[0] - 0.1;
							colorByValue.push(addItem);
						}
						colorByValue.push(item);
						if (idx == (Math.round(__dataObj["colorByValue"].length / 2)) + 1) {
							let addItem = Object.assign([], __dataObj["colorByValue"][idx]);
							addItem[0] = addItem[0] + 0.1;
							colorByValue.push(addItem);
						}
					}
					colorByValue.push([1, __dataObj["colorByValue"][__dataObj["colorByValue"].length - 1][1]]);

					let hisPercentColor = colorByValue[0][1];
					let bizPercentColor = colorByValue[0][1];
					let samePercentColor = colorByValue[0][1];
					let idxMaxLength = colorByValue.length - 1;
					function checkData(value, start, end) {
						if (value > start * 100 && value <= end * 100) {
							return true;
						}
						return false;
					};

					for (let idx = 0; idx <= idxMaxLength; idx++) {
						if (idx >= idxMaxLength) {
							continue;
						}
						if (
							checkData(__dataObj["samePercent"],
							colorByValue[idx][0],
							colorByValue[idx + 1][0])
						) {
							samePercentColor = blendColors(
								colorByValue[idx][1],
								colorByValue[idx + 1][1]
							);
						}
						if (
							checkData(hisPercent,
							colorByValue[idx][0],
							colorByValue[idx + 1][0])
						) {
							hisPercentColor = blendColors(
								colorByValue[idx][1],
								colorByValue[idx + 1][1]
							);
						}
						if (
							checkData(bizPercent,
							colorByValue[idx][0],
							colorByValue[idx + 1][0])
						) {
							bizPercentColor = blendColors(
								colorByValue[idx][1],
								colorByValue[idx + 1][1]
							);
						}
					}
					$("#hisPercent").css("color", hisPercentColor);
					$("#bizPercent").css("color", bizPercentColor);
					$("#samePercent").css("color", samePercentColor);
					*/

					createRatioChart(totalLength, sameDataLength, notSameDataLength);
					__dataObj.setDashLoadingMask(false);
					searchTag(true);
					//getQcTargetList(true);
				}
			},
			error: function(e) {
				MsgBox("Info", "차트 조회에 실패하였습니다.");
				__dataObj.setDashLoadingMask(false);
			}
		});
	};

	__dataObj["tagGrid"] = new tui.Grid({
		el: document.getElementById("tagList"), // 컨테이너 엘리먼트
		editingEvent: "",
		scrollX: true,
		scrollY: true,
		minRowHeight: 30,
		rowHeight: 30,
		columns: [
			{
				header: "태그",
				name: "TAGSN",
				hidden: 1,
				resizable: false
			},
			{
				header: "태그명",
				name: "TAG_NM",
				align: "center",
				width: getWidthByElementSize(220, 533.2, $("#tagList")[0]),
				whiteSpace: "nowrap",
				ellipsis: true,
				renderer: {
					attributes: {
						title: function(props) {
							return props.formattedValue;
						}
					}
				}
			},
			{
				header: "태그 설명",
				name: "TAG_DESC",
				align: "left",
				width: getWidthByElementSize(295, 533.2, $("#tagList")[0]),
				whiteSpace: "nowrap",
				ellipsis: true,
				renderer: {
					attributes: {
						title: function(props) {
							return props.formattedValue;
						}
					}
				}
			}
		],
		columnOptions: {
			resizable: true
		}
	});

	function tagListResize() {
		if (__dataObj["resized"] || !$("#tagList").data("max-height")) {
			$("#tagList").data("max-height", $("#tagList").height());
		}
		__dataObj["tagGrid"].setHeight($("#tagList").data("max-height"));
	};

	__dataObj["hisDataGrid"] = new tui.Grid({
		el: document.getElementById("hisDataList"), // 컨테이너 엘리먼트
		editingEvent: "dblclick",
		scrollX: true,
		scrollY: true,
		minRowHeight: 30,
		rowHeight: 30,
		columns: [
			{
				header: "날짜",
				name: "DATA_DT",
				align: "center",
				width: getWidthByElementSize(200, 595, $("#hisDataList")[0])
			}, {
				header: "태그명",
				name: "TAG_NM",
				align: "center",
				width: getWidthByElementSize(230, 595, $("#hisDataList")[0]),
				whiteSpace: "nowrap",
				ellipsis: true,
				renderer: {
					attributes: {
						title: function(props) {
							return props.formattedValue;
						}
					}
				}
			}, {
				header: "현재값",
				name: "TAG_BFR_VL_his",
				align: "center",
				width: getWidthByElementSize(145, 595, $("#hisDataList")[0])
			}
		],
		columnOptions: {
			resizable: true
		}
	});

	__dataObj["bizDataGrid"] = new tui.Grid({
		el: document.getElementById("bizDataList"), // 컨테이너 엘리먼트
		editingEvent: "dblclick",
		scrollX: true,
		scrollY: true,
		minRowHeight: 30,
		rowHeight: 30,
		columns: [
			{
				header: "날짜",
				name: "DATA_DT",
				align: "center",
				width: getWidthByElementSize(200, 595, $("#hisDataList")[0])
			}, {
				header: "태그명",
				name: "TAG_NM",
				align: "center",
				width: getWidthByElementSize(230, 595, $("#hisDataList")[0]),
				whiteSpace: "nowrap",
				ellipsis: true,
				renderer: {
					attributes: {
						title: function(props) {
							return props.formattedValue;
						}
					}
				}
			}, {
				header: "현재값",
				name: "TAG_BFR_VL_biz",
				align: "center",
				width: getWidthByElementSize(145, 595, $("#hisDataList")[0])
			}
		],
		columnOptions: {
			resizable: true
		}
	});

	function dataListResize(suffix) {
		if (__dataObj["resized"] || !$(`#\${suffix}DataList`).data("max-height")) {
			$(`#\${suffix}DataList`).data("max-height", $(`#\${suffix}DataList`).height());
		}
		__dataObj[suffix + "DataGrid"].setHeight($(`${"#${suffix}DataList"}`).data("max-height"));
	};

	function getFetchValues(tag_nm, from_dt, to_dt, dest) {
		let suffix = "biz";
		if (dest.startsWith("his")) {
			suffix = "his"
		}

		return new Promise(function(resolve, reject) {
			let obj = new Object();
			obj.cmd = "fetchValues"; // dest.toLowerCase().startsWith("his") ? "fetchValues" : "fetchSnapshots";
			obj.timeout = 15 * 1000;
			obj.dest = dest;
			obj.param = {};
			obj.param.start = from_dt;
			obj.param.end = to_dt;
			obj.param.span = 60;
			obj.param.tagList = [tag_nm];

			$.ajax ({
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "reqHistorian",
				dataType: "json",
				cache: true,
				data: JSON.stringify(obj),
				success: function(data) {
					if (!!data && !!data.param[0] && !!data.param[0].values && data.param[0].values.length > 0) {
						for (let hdata of data.param[0].values) {
							let time = moment(hdata.time).format("YYYY-MM-DD HH:mm:ss");
							if (!!__dataObj["dataList"][time]) {
								let val = Number(hdata.val);
								__dataObj["dataList"][time]["TAG_BFR_VL_" + suffix] = (val === "" || val === null || val === undefined ? null : val);
							}
						}
					}

					__dataObj["dataListOrg"] = JSON.parse(JSON.stringify(__dataObj["dataList"]));

					let gridDataSet = new Array();
					for (let time in __dataObj["dataList"]) {
						gridDataSet.push(__dataObj["dataList"][time]);
					}
					__dataObj[suffix + "DataGrid"].resetData(gridDataSet);
					dataListResize(suffix);
					resolve(data);
				},
				error: function(e) {
					console.error(e);
					MsgBox("Info", "데이터 조회에 실패하였습니다.");
					__dataObj.setLoadingMask(false);
					reject();
				}
			});
		});
	};

	// 데이터 보정 태그 목록 조회
	async function getQcTargetList(isFirst) {
		clearData(false);
		__dataObj["bizDataGrid"].resetData([]);
		__dataObj["hisDataGrid"].resetData([]);
		__dataObj["dataList"] = new Object();

		if (isFirst) {
			return;
		}

		if (__dataObj.getLoadingMask()) {
			return;
		}

		let from = moment($("#strtDate").val() + " " + $("#strtTime").val()).format("YYYY-MM-DD HH:mm:ss");
		let end = moment($("#endDate").val() + " " + $("#endTime").val()).format("YYYY-MM-DD HH:mm:ss");

		if ((new Date(end) - new Date(from)) > 7 * 24 * 60 * 60 * 1000) {
			MsgBox("Info", "최대 조회기간은 7일입니다.");
			return;
		}

		if (checkFromToInvaildate(from, end)) {
			let selectedTag = __dataObj["tagGrid"].getRow(__dataObj["tagGrid"].getFocusedCell().rowKey);
			if (!!!selectedTag) {
				//MsgBox("Info", "선택된 태그가 없습니다.");
				return;
			}
			__dataObj.setLoadingMask(true);
			let obj = {
				"tag_nm": selectedTag.TAG_NM,
				"from_dt": from,
				"to_dt": end
			}

			if (!!obj.tag_nm) {
				while (from <= end) {
					__dataObj["dataList"][from] = {
						"DATA_DT": from,
						"TAG_NM": obj.tag_nm,
						"TAG_BFR_VL_his": null,
						"TAG_BFR_VL_biz": null,
					};
					from = moment(from).add(1, "minute").format("YYYY-MM-DD HH:mm:ss");
				}

				let data_result = [];
				if (!$("#bizDataList").data("max-height")) {
					$("#bizDataList").data("max-height", $("#bizDataList").height());
				}
				if (!$("#hisDataList").data("max-height")) {
					$("#hisDataList").data("max-height", $("#hisDataList").height());
				}
				data_result.push(getFetchValues(obj.tag_nm, obj.from_dt, obj.to_dt, "historian"));
				data_result.push(getFetchValues(obj.tag_nm, obj.from_dt, obj.to_dt, "biznexus"));
				Promise.all(data_result).then(function(result) {
					dataListResize("biz");
					dataListResize("his");
					__dataObj.setLoadingMask(false);
				});
			} else {
			}
		} else {
			MsgBox("Info", "조회 기간을 확인해 주세요.");
			return;
		}
	};

	// 데이터 보정 저장 기능
	function insertDataQcHsty() {
		if (__dataObj.getLoadingMask()) {
			return;
		}
		if ($("button.save").hasClass("disabled")) {
			return;
		}
		__dataObj.setLoadingMask(true);

		let dest = __dataObj["arrowEvent"];
		if (!dest) {
			return;
		}

		let from_dt = moment($("#strtDate").val() + " " + $("#strtTime").val()).format("YYYY-MM-DD HH:mm:ss");
		let to_dt = moment($("#endDate").val() + " " + $("#endTime").val()).format("YYYY-MM-DD HH:mm:ss");
		let obj = {
			"cmd": "importData",
			"timeout": 15 * 1000,
			"dest": dest,
			"param": {
				"start": from_dt,
				"end": to_dt
			}
		};

		$.ajax ({
			type: "POST",
			contentType: "application/json; charset=UTF-8",
			url: "reqHistorian",
			dataType: "json",
			cache: true,
			data: JSON.stringify(obj),
			success: function(data) {
				MsgBox("Info", "데이터 일괄 보정이 시작되었습니다.");
				__dataObj.setLoadingMask(false);
				importStatus();
			},
			error: function(e) {
				console.error(e);
				MsgBox("Info", "데이터 일괄 보정에 실패하였습니다.");
				__dataObj.setLoadingMask(false);
			}
		});
	};

	function importStatus() {
		let obj = {
			"cmd": "importStatus",
			"timeout": 60 * 1000,
			"dest": "importStatus"
		};

		$.ajax ({
			type: "POST",
			contentType: "application/json; charset=UTF-8",
			url: "reqHistorian",
			dataType: "json",
			cache: true,
			data: JSON.stringify(obj),
			success: function(data) {
				if (data && data.param) {
					let total = data.param[0]["total"];
					let success = data.param[0]["success"];
					let progressBar = document.getElementById("importProgressBar");
					updateImportPercent(success / total * 100);
					if (total < 0) {
						progressBar.style.animation = "";
						clearInterval(__dataObj["importStatusInterval"]);
						__dataObj["importStatusInterval"] = null;
						destSetting(null);
						if (!__dataObj.getDashLoadingMask(true)) {
							getStatsData();
						}
					} else {
						if (__dataObj["importStatusInterval"] == null || __dataObj["importStatusInterval"] == undefined) {
							__dataObj["importStatusInterval"] = setInterval(importStatus, 5000);
						}
						progressBar.style.animationDuration = "0.5s";
						progressBar.style.animationIterationCount = "infinite";
						progressBar.style.animationName = "progress-blink-anim";
						progressBar.style.animationTimingFunction = "ease";
						setTimeout(() => progressBar.style.animationName = "", 1000);
						destSetting("all");
					}
				}
			},
			error: function(e) {
				console.error(e);
				MsgBox("Info", "보정중 여부 조회에 실패하였습니다.");
				__dataObj.setLoadingMask(false);
			}
		});
	};

	// 선택한 셀에 클래스 추가
	function onGridSelecting(grid, rowKey, columnName) {
		// 이전에 선택된 셀에서 클래스 제거
		if (__dataObj["previousRowKey"] !== null && __dataObj["previousColumnName"] !== null) {
			grid.removeCellClassName(__dataObj["previousRowKey"], __dataObj["previousColumnName"], "tui-grid-cell-selected");
		}

		// 새로 선택된 셀에 클래스 추가
		grid.addCellClassName(rowKey, columnName, "tui-grid-cell-selected");

		// 현재 선택된 셀을 이전 셀로 저장
		__dataObj["previousRowKey"] = rowKey;
		__dataObj["previousColumnName"] = columnName;
	};

	function searchTag(isFirst) {
		let tagNmVal = $("#input_tag_nm").val();
		let tagDescVal = $("#input_tag_desc").val();
		let filterDesc = [];
		/*
		if (tagNmVal || tagDescVal) {
			tagNmVal = tagNmVal == "*" ? "" : tagNmVal;
			tagDescVal = tagDescVal == "*" ? "" : tagDescVal;
			let filterTag = __dataObj["tagDataList"].filter(obj => obj.TAG_NM.includes(tagNmVal));
			filterDesc = filterTag.filter(obj => obj.TAG_DESC.includes(tagDescVal));
		}
		*/
		if (!isFirst) {
			let filterTag = __dataObj["tagDataList"].filter(obj => obj.TAG_NM.includes(tagNmVal));
			filterDesc = filterTag.filter(obj => obj.TAG_DESC.includes(tagDescVal));
		}
		__dataObj["tagGrid"].resetData(filterDesc);
		tagListResize();
		getQcTargetList(true);
	};

	function clearData(isDataClear) {
		let gridDataSet = new Array();
		if (isDataClear) {
			__dataObj["dataList"] = JSON.parse(JSON.stringify(__dataObj["dataListOrg"]));
			for (let time in __dataObj["dataList"]) {
				gridDataSet.push(__dataObj["dataList"][time]);
			}
		}
		if (__dataObj["arrowEvent"] == "all") {
			return;
		}
		if (__dataObj["samePercent"] == 100) {
			destSetting("all");
		} else {
			destSetting(null);
		}
		if (isDataClear) {
			__dataObj["hisDataGrid"].resetData(gridDataSet);
			__dataObj["bizDataGrid"].resetData(gridDataSet);
		}
	};

	function destSetting(dest) {
		if (!dest) {
			$("#toHisArrow rect").css("fill", "");
			$("#toHisArrow rect").css("stroke", "");
			$("#toHisArrow path").css("stroke", "");
			$("#toHisArrow").css("cursor", "");
			$("#toBizArrow rect").css("fill", "");
			$("#toBizArrow rect").css("stroke", "");
			$("#toBizArrow path").css("stroke", "");
			$("#toBizArrow").css("cursor", "");
			__dataObj["arrowEvent"] = null;
			$("button.save").addClass("disabled");
		} else if (dest.startsWith("his")) {
			$("#toHisArrow rect").css("fill", "");
			$("#toHisArrow rect").css("stroke", "");
			$("#toHisArrow path").css("stroke", "");
			$("#toHisArrow").css("cursor", "");
			$("#toBizArrow rect").css("fill", "#ECECEC");
			$("#toBizArrow rect").css("stroke", "#ECECEC");
			$("#toBizArrow path").css("stroke", "#ACACAC");
			$("#toBizArrow").css("cursor", "default");
			__dataObj["arrowEvent"] = "historian";
			$("button.save").removeClass("disabled");
		} else if (dest.startsWith("biz")) {
			$("#toHisArrow rect").css("fill", "#ECECEC");
			$("#toHisArrow rect").css("stroke", "#ECECEC");
			$("#toHisArrow path").css("stroke", "#ACACAC");
			$("#toHisArrow").css("cursor", "default");
			$("#toBizArrow rect").css("fill", "");
			$("#toBizArrow rect").css("stroke", "");
			$("#toBizArrow path").css("stroke", "");
			$("#toBizArrow").css("cursor", "");
			__dataObj["arrowEvent"] = "biznexus";
			$("button.save").removeClass("disabled");
		} else if (dest.startsWith("all")) {
			$("#toHisArrow rect").css("fill", "#ECECEC");
			$("#toHisArrow rect").css("stroke", "#ECECEC");
			$("#toHisArrow path").css("stroke", "#ACACAC");
			$("#toHisArrow").css("cursor", "default");
			$("#toBizArrow rect").css("fill", "#ECECEC");
			$("#toBizArrow rect").css("stroke", "#ECECEC");
			$("#toBizArrow path").css("stroke", "#ACACAC");
			$("#toBizArrow").css("cursor", "default");
			$("#arrowReset").css("cursor", "default");
			$("#arrowReset rect").css("fill", "#ECECEC");
			$("#arrowReset rect").css("stroke", "#ECECEC");
			$("#arrowReset path").css("stroke", "#ACACAC");
			$("#arrowReset").css("cursor", "default");
			__dataObj["arrowEvent"] = "all";
			$("button.save").addClass("disabled");
		}
	}

	function inputKeyDownEvent() {
		if (event.keyCode == 13 || event.key == "Enter") {
			searchTag();
		}
	};

	// 셀 클릭 이벤트 핸들러
	__dataObj["bizDataGrid"].on("click", (ev) => {
		const { rowKey, columnName } = ev;

		// 셀 클릭 시 onGridSelecting 실행
		onGridSelecting(ev.instance, rowKey, columnName);
	});

	__dataObj["hisDataGrid"].on("click", (ev) => {
		const { rowKey, columnName } = ev;

		onGridSelecting(ev.instance, rowKey, columnName);
	});

	__dataObj["tagGrid"].on("click", (ev) => {
		if (__dataObj.getLoadingMask()) {
			if ((__dataObj["previousRowKey"] != 0 && !__dataObj["previousRowKey"]) && !__dataObj["previousColumnName"]) {
				__dataObj["tagGrid"].focus(__dataObj["previousRowKey"], __dataObj["previousColumnName"], true);
			}
			return;
		}
		const { rowKey, columnName } = ev;

		onGridSelecting(ev.instance, rowKey, columnName);
		let selectedTag = __dataObj["tagGrid"].getRow(__dataObj["tagGrid"].getFocusedCell().rowKey);
		getQcTargetList();
	});

	$("#bizDataList .tui-grid-rside-area .tui-grid-body-area").on("scroll", function() {
		clearTimeout(__dataObj["scrollEvent"]);
		let el = $(this);
		__dataObj["scrollEvent"] = setTimeout(function() {
			$("#hisDataList .tui-grid-rside-area .tui-grid-body-area").animate({
				scrollTop: el.scrollTop()
			}, 0);
		}, 10);
	});

	$("#hisDataList .tui-grid-rside-area .tui-grid-body-area").on("scroll", function() {
		clearTimeout(__dataObj["scrollEvent"]);
		let el = $(this);
		__dataObj["scrollEvent"] = setTimeout(function() {
			$("#bizDataList .tui-grid-rside-area .tui-grid-body-area").animate({
				scrollTop: el.scrollTop()
			}, 0);
		}, 10);
	});

	$("#toBizArrow").on("click", function() {
		if (__dataObj["arrowEvent"] == "biznexus") {
			return;
		}
		if (__dataObj["arrowEvent"] == null) {
			destSetting("biz");
		}
	});

	$("#toHisArrow").on("click", function() {
		if (__dataObj["arrowEvent"] == "historian") {
			return;
		}
		if (__dataObj["arrowEvent"] == null) {
			destSetting("his");
		}
	});

	window.addEventListener("resize", function() {
		__dataObj["resized"] = true;
		__dataObj["tagGrid"].resetColumnWidths([
			getWidthByElementSize(220, 533.2, $("#tagList")[0]),
			getWidthByElementSize(300, 533.2, $("#tagList")[0])
		]);
		__dataObj["hisDataGrid"].resetColumnWidths([
			getWidthByElementSize(200, 595, $("#hisDataList")[0]),
			getWidthByElementSize(230, 595, $("#hisDataList")[0]),
			getWidthByElementSize(145, 595, $("#hisDataList")[0])
		]);
		__dataObj["bizDataGrid"].resetColumnWidths([
			getWidthByElementSize(200, 595, $("#bizDataList")[0]),
			getWidthByElementSize(230, 595, $("#bizDataList")[0]),
			getWidthByElementSize(145, 595, $("#bizDataList")[0])
		]);
		tagListResize();
		dataListResize("his");
		dataListResize("biz");
		__dataObj["resized"] = false;
	});

	function createCntChart(hisDataLength, bizDataLength, hisMissLength, bizMissLength) {
		if (__dataObj["dataCntChart"]) {
			__dataObj["dataCntChart"].destroy();
		}
		/*
		let hisDataLength = __dataObj["hisDataCount"];
		let bizDataLength = __dataObj["bizDataCount"];
		let hisMissLength = __dataObj["hisMissCount"];
		let bizMissLength = __dataObj["bizMissCount"]
		*/
		__dataObj["dataCntChart"] = Highcharts.chart("cntChart", {
			chart: {
				type: "column",
				animation: false,
				backgroundColor: "transparent"
			},
			exporting: {
				enabled: false,
				buttons: {
					contextButton: {
						style: {
							height: "1rem",
							width: "1rem",
							fontSize: "0.7rem"
						}
					}
				}
			},
			credits: {
				enabled: false
			},
			title: {
				text: "결측",
				align: "left",
				style: {
					fontSize: "larger",
					fontWeight: "normal",
					fontFamily: "Pretendard-SemiBold",
					marginBottom: "0.3rem"
				}
			},
			subtitle: {
				text: "",
				align: "left"
			},
			xAxis: {
				categories: ["Historian", "Biznexus"],
				crosshair: true,
				tickInterval: 0,
				gridLineWidth: 0,
				labels: {
					rotation: 0
				},
				labels: {
					style: {
						color: "#5D6D94"
					}
				},
				lineColor: "#5D6D94"
			},
			yAxis: {
				min: 0,
				title: {
					text: ""
				},
				gridLineWidth: 1,
				labels: {
					style: {
						color: "#5D6D94"
					}
				},
				lineColor: "#5D6D94"
			},
			legend: {
				enabled: false
			},
			tooltip: {
				valueDecimals: 0,
				valueSuffix: "개",
				shared: true,
				formatter: function() {
					let fontSize = "0.8rem";
					let color = "#1E1E1E";
					let points = this.points;
					let categoriesName = points[0].point.category;
					let result = `<span style="font-size: 0.9rem;color: \${color};">\${categoriesName}</span>` +
						`<br/>`;
					let total = points[0].point.stackTotal;

					for (let point of points) {
						let seriesName = point.series.name;
						let value = point.y;
						result += `<span style="color: \${point.color}; margin-bottom: 0.1rem;">● </span>` +
							`<span style="font-size: \${fontSize};color: \${color};">\${seriesName}: </span>` +
							`<span style="font-size: \${fontSize};color: \${color};">\${value}개</span>` +
							`<br/>`;
					}
					result += `<span style="margin-bottom: 0.1rem;">● </span>` +
						`<span style="font-size: \${fontSize};color: \${color};">Total: </span>` +
						`<span style="font-size: \${fontSize};color: \${color};">\${total}개</span>`;

					return result;
				},
			},
			plotOptions: {
				column: {
					stacking: "normal",
					pointPadding: 0.4,
					borderWidth: 0,
					dataLabels: {
						enabled: true,
						color: "#1E1E1E",
						inside: false,
						format: "{point.y}",
						y: 0,
						style: {
							fontSize: "0.65rem",
							fontFamily: "Pretendard-SemiBold",
							textOutline: "none"
						}
					}
				},
				series: {
					centerInCategory: true,
					animation: true
				}
			},
			series: [{
				name: "개수",
				data: [hisDataLength, bizDataLength],
				color: "#1199B7A0"
			}, {
				name: "결측수",
				data: [hisMissLength, bizMissLength],
				color: "#5EBDD8A0"
			}]
		});
		__dataObj["dataCntChart"].redraw();
	};

	function createRatioChart(totalLength, sameDataLength, notSameDataLength) {
		if (__dataObj["dataRatioChart"]) {
			__dataObj["dataRatioChart"].destroy();
		}
		let samePercent = __dataObj["samePercent"];
		__dataObj["dataRatioChart"] = Highcharts.chart("ratioChart", {
			chart: {
				plotBackgroundColor: null,
				plotBorderWidth: 0,
				plotShadow: false,
				type: "solidgauge",
				animation: false,
				backgroundColor: "transparent"
			},
			title: {
				text: "일치",
				align: "left",
				style: {
					fontSize: "larger",
					fontWeight: "normal",
					fontFamily: "Pretendard-SemiBold",
					marginBottom: "0.3rem"
				}
			},
			pane: {
				center: ["50%", "85%"],
				size: "140%",
				startAngle: -90,
				endAngle: 90,
				background: {
					borderRadius: 2,
					backgroundColor: "#F5F5F5",
					innerRadius: "60%",
					outerRadius: "100%",
					shape: "arc"
				}
			},
			exporting: {
				enabled: false
			},
			credits: {
				enabled: false
			},
			yAxis: {
				stops: __dataObj["colorByValue"],
				lineWidth: 0,
				tickWidth: 0,
				minorTickInterval: 50,
				tickAmount: 2,
				labels: {
					y: 15
				},
				min: 0,
				max: 100
			},
			tooltip: {
				shared: true,
				formatter: function() {
					let fontSize = "0.8rem";
					let color = "#1E1E1E";
					let seriesName = this.series.name;

					let result = `<span style="font-size: 0.9rem;">\${seriesName}</span>` +
						`<br/>`;
					result += `<span style="font-size: \${fontSize};color: \${color};">일치: </span>` +
						`<span style="font-size: \${fontSize};color: \${color};">\${sameDataLength}개</span>` +
						`<br/>`;
					result += `<span style="font-size: \${fontSize};color: \${color};">불일치: </span>` +
						`<span style="font-size: \${fontSize};color: \${color};">\${notSameDataLength}개</span>` +
						`<br/>`;

					result += `<span style="font-size: \${fontSize};color: \${color};">Total: </span>` +
						`<span style="font-size: \${fontSize};color: \${color};">\${totalLength}개</span>`;

					return result;
				},
			},
			plotOptions: {
				solidgauge: {
					borderRadius: 2,
					dataLabels: {
						useHTML: true,
						y: 0,
						borderWidth: 0,
						style: {
							textOutline: "none",
						}
					}
				},
				series: {
					centerInCategory: true,
					animation: true
				}
			},
			series: [{
				name: "일치성",
				data: [samePercent],
				dataLabels: {
					useHTML: false,
					//y: 0,
					formatter: function() {
						let point = this.point;
						let fontSize = "1.5rem";
						let color = this.color;//"#1E1E1E";
						let percent = point.y;
						result = `<span style="font-size: \${fontSize};color:\${color};">\${percent}%</span>`;

						return result;
					}
				},
			}]
		});
		__dataObj["dataRatioChart"].redraw();
	};

	function updateImportPercent(percent) {
		//percent = Math.round(percent * 10) / 10;
		percent = Math.round(percent);
		if (percent > 100) {
			percent = 100;
		} else if (percent < 0 || isNaN(Number(percent))) {
			percent = 0;
		}
		let progressBar = document.getElementById("importProgressBar");
		progressBar.style.height = `\${percent}%`;
		progressBar.setAttribute("data-percent", `\${percent}%`);
	};
	</script>
</body>
</html>