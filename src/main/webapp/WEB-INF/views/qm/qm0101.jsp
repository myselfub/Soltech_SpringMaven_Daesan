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
<title>시설물관리 - 데이터 개별 보정</title>
<script src="resources/js/tui/tui-grid.js"></script>
<link rel="stylesheet" href="resources/js/tui/tui-grid.css" />
<script src="resources/js/select2-4.0.13/dist/js/select2.min.js"></script>
<link rel="stylesheet"
	href="resources/js/select2-4.0.13/dist/css/select2.min.css" />
</head>
<body>
	<div id="main" class="main-screen">
		<div class="main-title">데이터 개별 보정</div>
		<div class="main-search-group">
			<div class="com-search-unit">
				<p>공정</p>
				<select id="sel_proc" onchange="onChangeProc();"></select>
				<p>데이터 소스</p>
				<select id="sel_dataSource" onchange="getQcTargetList(true);"></select>
				<p>조회 일시</p>
				<input type="date" id="strtDate" /> <input type="time"
					id="strtTime" />
				<p>~</p>
				<input type="date" id="endDate" /> <input type="time" id="endTime" />
				<!-- <button class="find" onclick="getQcTargetList();"></button> -->
			</div>
			<div class="com-search-unit">
				<button class="save disabled" onclick="insertDataQcHsty();"></button>
			</div>
		</div>
		<div class="main-data-group main-contents-grid2">
			<div class="main-contents-grid1" style="width: 30%;">
				<div class="grd-search-grp">
					<p class="grd-sub-title">태그 목록</p>
					<input type="text" id="input_tag_nm" class="search-ai-input"
						placeholder="태그명 검색" onkeydown="inputKeyDownEvent(this);" /> <input
						type="text" id="input_tag_desc" class="search-ai-input"
						placeholder="태그 설명 검색" onkeydown="inputKeyDownEvent(this);" />
					<button id="btnSearch" class="find" onClick="searchTag();"></button>
				</div>
				<div id="tagList" class="tui-grid-row-select-table"
					style="height: 93%;"></div>
			</div>
			<div class="main-contents-grid1" style="width: 40%;">
				<div class="grd-search-grp">
					<p class="grd-sub-title">데이터 목록</p>
				</div>
				<div id="dataList" style="height: 93%;"></div>
			</div>
			<div class="main-contents-grid1" style="width: 30%;">
				<div class="grd-search-grp">
					<p class="grd-sub-title">데이터 보정</p>
				</div>
				<div class="main-contents-grid1" style="row-gap: 1.25rem;">
					<div class="main-contents-grid1"
						style="padding: 0.1rem 0.65rem; row-gap: 0.95rem;">
						<h3 style="padding-bottom: 1rem; border-bottom: 2px solid #CACACA;">개별보정</h3>
						<p style="padding: 0px 0.3rem;">왼쪽 표의 보정 후 항목에 직접 입력한 값으로 보정합니다.</p>
					</div>
					<div class="main-contents-grid1"
						style="padding: 0.1rem 0.65rem; row-gap: 0.95rem;">
						<h3 style="padding-bottom: 1rem; border-bottom: 2px solid #CACACA;">일괄보정</h3>
						<p style="padding: 0px 0.3rem;">왼쪽 표에서 선택된 범위의 값을 아래에 입력한 값으로 일괄
							보정합니다.</p>
						<div class="main-contents-grid2" style="padding-left: 1.25rem;">
							<p class="content-label">보정 값 =</p>
							<input type="number" id="input_bc">
							<button class="btn" onclick="onClickBCApply();">적용</button>
						</div>
					</div>
					<div class="main-contents-grid1"
						style="padding: 0.1rem 0.65rem; row-gap: 0.95rem;">
						<h3 style="padding-bottom: 1rem; border-bottom: 2px solid #CACACA;">연산 보정</h3>
						<p style="padding: 0px 0.3rem;">왼쪽 표에서 선택된 범위의 값을 아래에서 선택한 연산자와
							입력한 값으로 연산 보정합니다.</p>
						<div class="main-contents-grid2" style="padding-left: 1.25rem;">
							<p class="content-label">연산자 =</p>
							<button class="btn opr active">＋</button>
							<button class="btn opr">－</button>
							<button class="btn opr">×</button>
							<button class="btn opr">÷</button>
						</div>
						<div class="main-contents-grid2" style="padding-left: 1.25rem;">
							<p class="content-label">보정 값 =</p>
							<input type="number" id="input_cc">
							<button class="btn" onclick="onClickCCApply();">적용</button>
						</div>
					</div>
					<div class="main-contents-grid1"
						style="padding: 0.1rem 0.65rem; row-gap: 0.95rem;">
						<h3 style="padding-bottom: 1rem; border-bottom: 2px solid #CACACA;">보정 룰</h3>
						<p style="padding: 0px 0.3rem;">왼쪽 표에서 선택된 범위의 값을 아래에서 선택한 룰로
							보정합니다.</p>
						<div class="main-contents-grid2" style="padding-left: 1.25rem;">
							<p class="content-label">룰</p>
							<!-- <select id="input_rule"> -->
							<input id="input_rule" type="search" class="auto-complate-input"
								list="datas_rule" placeholder="보정 룰 선택">
							<datalist id="datas_rule" class="auto-complate-datas"></datalist>
							<button class="btn" onclick="onClickRuleApply();">적용</button>
						</div>
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

		//initSelect();

		// 공정 목록 조회
		await getDataSourceList("sel_dataSource", getDataSourceListLogic);
		await getProcInfoList();
		__dataObj["ruleList"] = await getRuleList("datas_rule");
		// 공정별 태그 목록 조회
		onChangeProc();
	};

	const __dataObj = {
		"digits": 1000,
		"tagDataList": [],
		"tagGrid": [],
		"destDataList": [],
		"dataList": {},
		"dataGrid": {},
		"dataListTemp": {},
		"datasave": null,
		"dbsave": null,
		"previousRowKey": null,
		"previousColumnName": null,
		"resized": false,
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
		}
	};

	// 공정별 태그 목록 조회
	async function onChangeProc() {
		// 태그 설정
		__dataObj["dataGrid"].resetData([]);
		__dataObj["tagGrid"].resetData([]);
		let proc_cd = $("#sel_proc option:selected").val();
		/*
		if ($("#input_tag_nm").val() == "*") {
			$("#input_tag_nm").val("");
		}
		if ($("#input_tag_desc").val() == "*") {
			$("#input_tag_desc").val("");
		}
		*/
		getProcTagList(proc_cd);
	};

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
				searchTag(true);

				// 첫 번째 데이터를 선택 => 241119 초기 조회 삭제
				/*
				if (data.length > 0) {
					__dataObj["tagGrid"].focus(0, "TAG_NM");
					getQcTargetList();
				}
				*/
			},
			error: function(e) {
				MsgBox("Info", "태그 목록 조회에 실패하였습니다.");
			}
		});
	};

	function getDataSourceListLogic(data) {
		__dataObj["destDataList"] = data;
		let sel_id = "sel_dataSource";
		$("#" + sel_id + " option").remove();
		for (let obj of data) {
			$("#" + sel_id).append(`${'<option value="${obj.CD_ID}">${obj.CD_NM}</option>'}`);
		}
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
			}, {
				header: "태그명",
				name: "TAG_NM",
				align: "center",
				width: getWidthByElementSize(220, 528, $("#tagList")[0]), // 13.75 * getFontSizeByMedia()
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
				header: "태그 설명",
				name: "TAG_DESC",
				align: "left",
				width: getWidthByElementSize(290, 528, $("#tagList")[0]), // 18.75 * getFontSizeByMedia()
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

	__dataObj["tagGrid"].on("click", (ev) => {
		if (__dataObj.getLoadingMask()) {
			if ((__dataObj["previousRowKey"] != 0 && !__dataObj["previousRowKey"]) && !__dataObj["previousColumnName"]) {
				__dataObj["tagGrid"].focus(__dataObj["previousRowKey"], __dataObj["previousColumnName"], true);
			}
			return;
		}
		const { rowKey, columnName } = ev;

		// 셀 클릭 시 onGridSelecting 실행
		onGridSelecting(ev.instance, rowKey, columnName);
		getQcTargetList();
	});

	__dataObj["dataGrid"] = new tui.Grid({
		el: document.getElementById("dataList"), // 컨테이너 엘리먼트
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
				width: getWidthByElementSize(200, 703, $("#dataList")[0]) // 12.5 * getFontSizeByMedia()
			}, {
				header: "태그명",
				name: "TAG_NM",
				align: "center",
				width: getWidthByElementSize(220, 703, $("#dataList")[0]) // 13.75 * getFontSizeByMedia()
			}, {
				header: "현재값",
				name: "TAG_BFR_VL",
				align: "center",
				width: getWidthByElementSize(130, 703, $("#dataList")[0]) // 8.4 * getFontSizeByMedia()
			}, {
				header: "보정값",
				name: "TAG_AFT_VL",
				align: "center",
				width: getWidthByElementSize(135, 703, $("#dataList")[0]), // 8.4 * getFontSizeByMedia(),
				editor: "text"
			}, {
				header: "보정 사유",
				name: "REVISN_RESN",
				hidden: 1,
				resizable: false
			}, {
				header: "보정 했는지",
				name: "is_qc",
				hidden: 1,
				resizable: false
			},
		],
		columnOptions: {
			resizable: true
		}
	});

	// 개별 보정
	__dataObj["dataGrid"].on("editingFinish", (ev) => {
		let row = ev.rowKey;
		let aftValue = ev.value === "" ? null : Number(ev.value); // 사용자가 입력한 값
		if (isNaN(aftValue)) {
			__dataObj["dataGrid"].setValue(row, "TAG_AFT_VL", "");
			return;
		}
		aftValue = Math.round(aftValue * __dataObj["digits"]) / __dataObj["digits"];
		let bfrValue = Number(__dataObj["dataGrid"].getValue(row, "TAG_BFR_VL"));
		let date = __dataObj["dataGrid"].getValue(row, "DATA_DT");

		if (aftValue != null && aftValue != "" && aftValue != bfrValue) {
			__dataObj["dataGrid"].setValue(row, "is_qc", true);
			__dataObj["dataGrid"].setValue(row, "TAG_AFT_VL", aftValue);
			$("button.save").removeClass("disabled");
		} else {
			__dataObj["dataGrid"].setValue(row, "is_qc", false);
			__dataObj["dataGrid"].setValue(row, "TAG_AFT_VL", "");
		}
	});

	// 셀 클릭 이벤트 핸들러
	__dataObj["dataGrid"].on("click", (ev) => {
		const { rowKey, columnName } = ev;

		// 셀 클릭 시 onGridSelecting 실행
		onGridSelecting(ev.instance, rowKey, columnName);
	});

	// 붙여넣기 이벤트 핸들러
	__dataObj["dataGrid"].on("beforeChange", (ev) => {
		if (ev.origin == "paste") {
			ev.changes.forEach(item => {
				let bfrValue = item["value"];
				let aftValue = item["nextValue"];
				if (aftValue != null && aftValue != "" && aftValue != bfrValue) {
					__dataObj["dataGrid"].setValue(item.rowKey, "is_qc", true, false);
					$("button.save").addClass("disabled");
				}
			});
		}
	});

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

	function gridListResize(gridType) {
		if (__dataObj["resized"] || !$(`#\${gridType}List`).data("max-height")) {
			$(`#\${gridType}List`).data("max-height", $(`#\${gridType}List`).height());
		}
		__dataObj[`\${gridType}Grid`].setHeight($(`#\${gridType}List`).data("max-height"));
	};

	window.addEventListener("resize", function() {
		__dataObj["resized"] = true;
		document.querySelectorAll(".grd-sub-title").forEach(emt => {
			if (emt.offsetWidth < emt.scrollWidth) {
				emt.title = emt.textContent;
			} else {
				emt.title = "";
			}
		});
		__dataObj["tagGrid"].resetColumnWidths([
			getWidthByElementSize(220, 528, $("#tagList")[0]),
			getWidthByElementSize(300, 528, $("#tagList")[0])
		]);
		__dataObj["dataGrid"].resetColumnWidths([
			getWidthByElementSize(200, 703, $("#dataList")[0]),
			getWidthByElementSize(220, 703, $("#dataList")[0]),
			getWidthByElementSize(135, 703, $("#dataList")[0]),
			getWidthByElementSize(135, 703, $("#dataList")[0])
		]);
		gridListResize("tag");
		gridListResize("data");
		__dataObj["resized"] = false;
	});

	$(".btn.opr").click(function(e) {
		$(".btn.opr").removeClass("active");
		$(this).addClass("active");
	});

	function getFetchValues(tag_nm, from_dt, to_dt) {
		return new Promise((resolve, reject) => {
			let dest = $("#sel_dataSource option:selected").val();
			let obj = new Object();
			obj.cmd = "fetchValues"; // "fetchSnapshots"
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
				data: JSON.stringify(obj)
			}).done(function(data) {
				resolve(data);
			});
		});
	};

	// 데이터 보정 태그 목록 조회
	async function getQcTargetList(isFirst) {
		if (__dataObj.getLoadingMask()) {
			return;
		}
		__dataObj["dataGrid"].resetData([]);
		__dataObj["dataList"] = new Object();

		if (isFirst) {
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
						"TAG_BFR_VL": null,
						"TAG_AFT_VL": null,
						"is_qc": false
					};
					from = moment(from).add(1, "minute").format("YYYY-MM-DD HH:mm:ss");
				}

				// 히스토리안 조회 (보정 후 값)
				let data_result = await getFetchValues(obj.tag_nm, obj.from_dt, obj.to_dt);
				if (data_result == undefined) {
					setTimeout(() => {
						getQcTargetList(true);
					}, 1000);
					return;
				}
				/*
				if (typeof(data_result.cmd) != "undefined") {
					if (data_result.cmd == "error" && data_result.param.code == 10054) {
						setTimeout(() => {
							getQcTargetList();
						}, 1000);
					}
				} else {
				*/
				if (!!data_result && !!data_result.param[0] && !!data_result.param[0].values && data_result.param[0].values.length > 0) {
					for (let hdata of data_result.param[0].values) {
						let time = moment(hdata.time).format("YYYY-MM-DD HH:mm:ss");
						if (!!__dataObj["dataList"][time]) {
							let val = Number(hdata.val);
							__dataObj["dataList"][time].TAG_BFR_VL = (val === "" || val === null || val === undefined ? null : val);
						}
					}
				}

				let gridDataSet = new Array();
				for (let time in __dataObj["dataList"]) {
					gridDataSet.push(__dataObj["dataList"][time]);
				}
				__dataObj["dataGrid"].resetData(gridDataSet);
				gridListResize("data");

				$("#input_bc").val("");
				$("#input_cc").val("");
				$("#input_rule").val("");
				$(".btn.opr").removeClass("active");
				$(".btn.opr:eq(0)").addClass("active");

				/*
				// 보정 이력 조회
				let qcdata = new Promise((resolve, reject) => {
					$.ajax ({
						type: "POST",
						contentType: "application/json; charset=utf-8",
						cache: false,
						url: "getDataQcHstyList",
						dataType: "json",
						data: JSON.stringify(obj),
						success: function(data) {
							resolve(data);
						}
					});
				});

				qcdata.then((data)=>{
					// 데이터 셋 만들기
					let gridDataSet = new Array();
					for (let time in __dataObj["dataList"]) {
						gridDataSet.push(__dataObj["dataList"][time]);
					}
					__dataObj["dataGrid"].resetData(gridDataSet);
					__dataObj["dataGrid"].setHeight($("#dataList").height());

					$("#input_bc").val("");
					$("#input_cc").val("");
					$("#input_rule").val("");
					$(".btn.opr").removeClass("active");
					$(".btn.opr:eq(0)").addClass("active");
					$("#revisn_resn").val("");
				});
				*/
				//}
				__dataObj.setLoadingMask(false);
			} else {
				$("#input_bc").val("");
				$("#input_cc").val("");
				$("#input_rule").val("");
				$(".btn.opr").removeClass("active");
				$(".btn.opr:eq(0)").addClass("active");
			}
		} else {
			MsgBox("Info", "조회 기간을 확인해 주세요.");
			return;
		}
	};

	// 일괄 보정 적용 버튼 클릭 시
	function onClickBCApply() {
		let row = __dataObj["dataGrid"].getSelectionRange();
		let focus = __dataObj["dataGrid"].getFocusedCell();

		if (row == null && focus.rowKey == null) {
			alert("범위를 선택해 주세요");
		} else {
			let value = $("#input_bc").val();

			if (row != null) {
				// 범위 선택인 경우
				let srow = row.start[0];
				let erow = row.end[0];

				for (let i = srow; i <= erow; i++) {
					setGridBCValue(i, value);
				}
			} else {
				// 셀 하나 선택한 경우
				setGridBCValue(focus.rowKey, value);
			}
		}

		function setGridBCValue(i, aftValue) {
			let bfrValue = Number(__dataObj["dataGrid"].getValue(i, "TAG_BFR_VL"));
			let date = __dataObj["dataGrid"].getValue(i, "DATA_DT");
			if (aftValue != bfrValue) {
				__dataObj["dataGrid"].setValue(i, "is_qc", true);
				__dataObj["dataGrid"].setValue(i, "TAG_BFR_VL", bfrValue);
				__dataObj["dataGrid"].setValue(i, "TAG_AFT_VL", aftValue);
				$("button.save").removeClass("disabled");
			} else {
				__dataObj["dataGrid"].setValue(i, "is_qc", false);
				__dataObj["dataGrid"].setValue(i, "TAG_AFT_VL", "");
			}
		};
	};

	// 연산 보정 적용 버튼 클릭 시
	function onClickCCApply() {
		let row = __dataObj["dataGrid"].getSelectionRange();
		let focus = __dataObj["dataGrid"].getFocusedCell();

		if (row == null && focus == null) {
			alert("범위를 선택해 주세요");
		} else {
			let oper = $(".btn.opr.active").text();
			let value = Number($("#input_cc").val());

			if (row != null) {
				let srow = row.start[0];
				let erow = row.end[0];

				for (let i = srow; i <= erow; i++) {
					setGridCCValue(i, value, oper);
				}
			} else {
				setGridCCValue(focus.rowKey, value, oper);
			}
		}

		function setGridCCValue(i, aftValue, oper) {
			let bfrValue = Number(__dataObj["dataGrid"].getValue(i, "TAG_BFR_VL"));
			let result = "";
			let remark = "";
			switch(oper) {
				case "＋":
					result = bfrValue + aftValue;
					remark = "[연산보정] 기존값(" + bfrValue + ") + 보정 값(" + aftValue + ")";
					break;
				case "－":
					result = bfrValue - aftValue;
					remark = "[연산보정] 기존값(" + bfrValue + ") - 보정 값(" + aftValue + ")";
					break;
				case "×":
					result = bfrValue * aftValue;
					remark = "[연산보정] 기존값(" + bfrValue + ") x 보정 값(" + aftValue + ")";
					break;
				case "÷":
					result = bfrValue / aftValue;
					remark = "[연산보정] 기존값(" + bfrValue + ") / 보정 값(" + aftValue + ")";
					break;
			}

			if (result == bfrValue) {
				// 보정 전이랑 같은 값으로 변경하면 보정 안한거
				__dataObj["dataGrid"].setValue(i, "is_qc", false);
				__dataObj["dataGrid"].setValue(i, "TAG_AFT_VL", "");
			} else {
				__dataObj["dataGrid"].setValue(i, "is_qc", true);
				__dataObj["dataGrid"].setValue(i, "TAG_AFT_VL", result);
				$("button.save").removeClass("disabled");
			}
		};
	};

	// 룰 적용 버튼 클릭 시
	function onClickRuleApply() {
		let row = __dataObj["dataGrid"].getSelectionRange();

		if (!!!$("#input_rule").val()) {
			alert("룰을 선택해 주세요");
		} else {
			let ruleObj = __dataObj["ruleList"].find(obj => obj.rule_nm == $("#input_rule").val());

			if (row != null) {
				let startRow = row.start[0];
				let endRow = row.end[0];

				__dataObj["dataListTemp"] = {};
				let dataObjKeys = Object.keys(__dataObj["dataList"]);
				for (let idx = startRow; idx <= endRow; idx++) {
					__dataObj["dataListTemp"][dataObjKeys[idx]] = __dataObj["dataList"][dataObjKeys[idx]];
				}
			} else {
				//전체 보정
				__dataObj["dataListTemp"] = JSON.parse(JSON.stringify(__dataObj["dataList"]));
			}
			let strFunc = ruleObj["rule_cn"].replaceAll('${"${DATA}"}', '__dataObj["dataListTemp"]');
			//let revisnData = __linearInterpolation();
			let revisnData = null;
			try {
				revisnData = eval(strFunc);
			} catch (e) {
				MsgBox("Error", "보정 로직에 오류가 있습니다.");
				console.error(e);
				return;
			}
			let gridDataSet = [];
			for (let key of Object.keys(__dataObj["dataList"])) {
				if (!!revisnData[key] && !!revisnData[key]["TAG_AFT_VL"]) {
					let value = Math.round(revisnData[key]["TAG_AFT_VL"] * __dataObj["digits"]) / __dataObj["digits"]
					__dataObj["dataList"][key]["TAG_AFT_VL"] = value;
					__dataObj["dataList"][key]["is_qc"] = true;
					$("button.save").removeClass("disabled");
				}
				gridDataSet.push(__dataObj["dataList"][key]);
			}
			__dataObj["dataGrid"].resetData(gridDataSet);
		}
	};

	function makeBizOutValueObj(dest, list) {
		let req = new Object();
		req.cmd = "putValues";
		req.timeout = 60 * 1000;
		req.dest = dest;
		req.param = new Array();

		for (let obj of list) {
			let now = new Date(Date.now());
			let val = new Object();

			val.name = obj.tag_nm;
			if (obj.dest.toLowerCase().startsWith("his")) {
				val.time = obj.time;
			} else if (obj.dest.toLowerCase().startsWith("biz")) {
				val.quality = 192;
				val.time = obj.time + ".000";
			}
			val.val = (obj.val == null ? "" : obj.val).toString();

			req.param.push(val);
		}

		return req;
	};

	__dataObj["dbsave"] = (req) => new Promise((resolve, reject) => {
		$.ajax ({
			type: "POST",
			contentType: "application/json; charset=utf-8",
			cache: false,
			url: "insertDataQcHsty",
			dataType: "json",
			data: JSON.stringify({list: req}),
			success: function(data) {
				resolve(data);
			}
		});
	});

	__dataObj["datasave"] = function(dest, req) {
		return new Promise((resolve, reject) => {
			$.ajax ({
				type: "POST",
				contentType: "application/json; charset=utf-8",
				cache: false,
				url: "reqHistorian",
				dataType: "json",
				data: JSON.stringify(makeBizOutValueObj(dest, req)),
				success: function(data) {
					resolve(data);
				},
				error: function(e) {
					console.error(e);
					reject();
				}
			});
		});
	};

	// 데이터 보정 저장 기능
	async function insertDataQcHsty() {
		if (__dataObj.getLoadingMask()) {
			return;
		}
		if ($("button.save").hasClass("disabled")) {
			return;
		}
		let dest = $("#sel_dataSource option:selected").val();
		if (dest.toLowerCase().startsWith("biz")) {
			alert("BizNexus는 보정을 지원하지 않습니다.");
			return;
		}
		__dataObj.setLoadingMask(true);
		// {tag_nm: @, data_dt: "YYYY-MM-DD HH24:MI:SS", tag_bfr_vl: @, tag_aft_vl: @}
		let data = __dataObj["dataGrid"].getData();
		let list = new Array(); // db 저장할 이력 목록
		let h_list = new Array(); // historian 저장할 요청 목록

		let focusedData = __dataObj["tagGrid"].getRow(__dataObj["tagGrid"].getFocusedCell().rowKey);
		let tag_nm = focusedData.TAG_NM;
		let tagsn = focusedData.TAGSN;
		let revisn_resn = "개별보정";

		let qcList = new Array();
		for (let d of data) {
			if (d.is_qc) {
				qcList.push(d);
			}
		}

		let resCnt = 0;
		if (!!!qcList.length) {
			MsgBox("Info", "수정할 데이터가 없습니다.");
			__dataObj.setLoadingMask(false);
			$("button.save").addClass("disabled");
			return;
		}
		/*
		for (let d of qcList) {
			let hsaveObj = {
				tag_nm: tag_nm,
				time: d.DATA_DT,
				val: Math.round(Number(d.TAG_AFT_VL) * __dataObj["digits"]) / __dataObj["digits"],
			};
			await __dataObj["datasave"](dest, hsaveObj).then((hres) => {
				if (hres.cmd == "error") {
					qcList.push(d);
					resCnt++;
				} else {
					let dbsaveObj = {
						tag_nm: tag_nm,
						data_dt: d.DATA_DT,
						tag_bfr_vl: (d.TAG_BFR_VL == null ? null : Math.round(Number(d.TAG_BFR_VL)) * __dataObj["digits"] / __dataObj["digits"]),
						tag_aft_vl: (d.TAG_AFT_VL == null ? null : Math.round(Number(d.TAG_AFT_VL)) * __dataObj["digits"] / __dataObj["digits"]),
						revisn_resn: revisn_resn,
						revisn_remark: dest
					};
					__dataObj["dbsave"](dbsaveObj).then((dbres) => {
						resCnt++;
						if (qcList.length == resCnt) {
							saveCallback();
						}
					});
				}
			});
		}
		*/
		let hsaveList = [];
		let dbsaveList = [];
		for (let d of qcList) {
			let hsaveObj = {
				tag_nm: tag_nm,
				time: d.DATA_DT,
				val: Math.round(Number(d.TAG_AFT_VL) * __dataObj["digits"]) / __dataObj["digits"],
				dest: dest
			};
			hsaveList.push(hsaveObj);
			let dbsaveObj = {
				tag_nm: tag_nm,
				data_dt: d.DATA_DT,
				tag_bfr_vl: (d.TAG_BFR_VL == null || d.TAG_AFT_VL == "" ? "" : Math.round(Number(d.TAG_BFR_VL)) * __dataObj["digits"] / __dataObj["digits"]),
				tag_aft_vl: (d.TAG_AFT_VL == null || d.TAG_AFT_VL == "" ? "" : Math.round(Number(d.TAG_AFT_VL)) * __dataObj["digits"] / __dataObj["digits"]),
				revisn_resn: revisn_resn,
				revisn_remark: dest
			};
			dbsaveList.push(dbsaveObj);
		}
		let failed = false;
		let dataLength = hsaveList.length;
		let step = 200;
		for (let idx = 0; idx < dataLength; idx += step) {
			let sliceHsaveList = hsaveList.slice(idx, idx + step);
			let sliceDbsaveList = dbsaveList.slice(idx, idx + step);
			await __dataObj["datasave"](dest, sliceHsaveList).then((hres) => {
				__dataObj["dbsave"](sliceDbsaveList).then((dbres) => {
				}).catch((err) => {
					failed = true;
				});
			}).catch((err) => {
				failed = true;
			});
			await sleep(700);
		}
		saveCallback();

		function sleep(ms) {
			return new Promise(resolve => setTimeout(resolve, ms));
		};

		function saveCallback() {
			setTimeout(function() {
				$("#input_bc").val("");
				$("#input_cc").val("");
				$("#input_rule").val("");
				//$("#revisn_resn").val("");
				if (failed) {
					MsgBox("Info", "데이터 개별 보정이 종료되었으나, 일부는 실패하였습니다.");
				} else {
					MsgBox("Info", "데이터 개별 보정이 완료되었습니다.");
				}
				$("button.save").addClass("disabled");
				__dataObj.setLoadingMask(false);
				getQcTargetList(true);
			}, 1000);
		};
	};

	async function initSelect() {
		await getRuleList("input_rule", function(ruleData) {
			__dataObj["ruleList"] = ruleData;
			$("#input_rule").select2({
				data: ruleData.map(item => {return {id: item.rule_id, text: item.rule_nm }}),
				placeholder: "보정 룰 선택",
				allowClear: true
			});
		});
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
		gridListResize("tag");
		gridListResize("data");
		getQcTargetList(true);
	};

	function inputKeyDownEvent() {
		if (event.keyCode == 13 || event.key == "Enter") {
			searchTag();
		}
	};

	function __linearInterpolation() {
		let datas = __dataObj["dataListTemp"]; // ${DATA}
		let dataKeys = Object.keys(datas);
		let dataLength = dataKeys.length;
		let noneDataIndexList = [];

		dataKeys.forEach((key, idx) => {
			if (!!!datas[key]["TAG_BFR_VL"]) {
				noneDataIndexList.push(idx);
			}
		});

		noneDataIndexList.forEach(idx => {
			let leftIdx = idx - 1;
			let rightIdx = idx + 1;

			while (leftIdx >= 0 && !!!datas[dataKeys[leftIdx]]["TAG_BFR_VL"]) {
				leftIdx--;
			}
			while (rightIdx < dataLength && !!!datas[dataKeys[rightIdx]]["TAG_BFR_VL"]) {
				rightIdx++;
			}

			if (leftIdx >= 0 && rightIdx < dataLength) {
				let leftValue = datas[dataKeys[leftIdx]]["TAG_BFR_VL"];
				let rightValue = datas[dataKeys[rightIdx]]["TAG_BFR_VL"];
				let reg = new RegExp("/^-?\d+(\.\d+)?$/");

				if (typeof leftValue === "string") {
					if (reg.test(leftValue)) {
						leftValue = parseFloat(leftValue);
					} else {
						leftValue = parseInt(leftValue, 10);
					}
				}
				if (typeof rightValue === "string") {
					if (reg.test(rightValue)) {
						rightValue = parseFloat(rightValue);
					} else {
						rightValue = parseInt(rightValue, 10);
					}
				}

				let calcValue = leftValue + ((rightValue - leftValue) * (idx - leftIdx)) / (rightIdx - leftIdx);
				datas[dataKeys[idx]]["TAG_AFT_VL"] = Math.round(calcValue * __dataObj["digits"]) / __dataObj["digits"];
			} else if (leftIdx >= 0) {
				datas[dataKeys[idx]]["TAG_AFT_VL"] = datas[dataKeys[leftIdx]]["TAG_BFR_VL"];
			} else if (rightIdx < dataLength) {
				datas[dataKeys[idx]]["TAG_AFT_VL"] = datas[dataKeys[rightIdx]]["TAG_BFR_VL"];
			}
		});
		return datas;
	};
	</script>
</body>
</html>