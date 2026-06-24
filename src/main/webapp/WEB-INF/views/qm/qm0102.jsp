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
<title>시설물관리 - 데이터 보정 이력</title>
<script src="resources/js/tui/tui-grid.js"></script>
<link rel="stylesheet" href="resources/js/tui/tui-grid.css" />
</head>
<body>
	<div id="main" class="main-screen">
		<div class="main-title">데이터 보정 이력</div>
		<div class="main-search-group">
			<div class="com-search-unit">
				<p>공정</p>
				<select id="sel_proc" onchange="onChangeProc();"></select>
				<p>데이터 소스</p>
				<select id="sel_dataSource"></select>
				<p>조회 일시</p>
				<input type="date" id="strtDate"> <input type="time"
					id="strtTime">
				<p>~</p>
				<input type="date" id="endDate"> <input type="time"
					id="endTime">
				<button class="find" onclick="onChangeProc();"></button>
			</div>
			<div class="com-search-unit"></div>
		</div>
		<div class="main-data-group main-contents-grid2">
			<div class="jsgrid-table-main main-contents-grid1" style="width: 30%;">
				<div class="grd-search-grp">
					<p class="grd-sub-title">태그 목록</p>
					<input type="text" id="input_tag_nm" class="search-ai-input"
						placeholder="태그명 검색" onkeydown="onEnterSearch(event)" /> <input
						type="text" id="input_tag_desc" class="search-ai-input"
						placeholder="태그 설명 검색" onkeydown="onEnterSearch(event)" />
					<button id="btnSearch" class="find" onClick="searchTag()"></button>
					<!--
					<div class="checkbox-container">
						<input id="checkIsRevisn" type="checkbox" name="isRevisn" checked="checked" />
						<label for="checkIsRevisn">보정여부</label>
					</div>
					-->
				</div>
				<div id="tagList" class="proc-tag-List" style="height: 93%"></div>
			</div>
			<div class="jsgrid-table-main main-contents-grid1" style="width: 70%;">
				<div class="grd-search-grp">
					<p class="grd-sub-title">보정 이력 목록</p>
				</div>
				<div id="dataList" class="event-list" style="height: 93%"></div>
			</div>
		</div>
	</div>
	<script>
	const __dataObj = {
		"tagGrid": null,
		"dataGrid": null,
		"tagDataListOrg": [],
		"tagDataList": [],
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
		"previousRowKey": null,
		"previousColumnName": null,
		"startX": 0,
		"startWidth": 0,
		"changeWidth": 0
	};

	// 처음 페이지 로드시
	window.onload = async function() {
		// 조회기간 초기설정
		let start = new Date(), end = new Date();
		start.setHours(end.getHours() - 24);
		end.setHours(end.getHours() + 1);

		setDateTime($("#strtDate"), $("#strtTime"), start);
		setDateTime($("#endDate"), $("#endTime"), end);

		// 공정 목록 조회
		await getDataSourceList("sel_dataSource", getDataSourceListLogic);
		await getProcInfoList();
		/*
		// 241119 삭제
		$("#checkIsRevisn").change(function() {
			searchTag();
		});
		*/
		// 공정별 태그 목록 조회
		onChangeProc();
	};

	// 공정별 태그 목록 조회
	async function onChangeProc() {
		// jsGrid 초기화
		__dataObj["tagGrid"].resetData([]);
		__dataObj["dataGrid"].resetData([]);
		/*
		if ($("#input_tag_nm").val() == "*") {
			$("#input_tag_nm").val("");
		}
		if ($("#input_tag_desc").val() == "*") {
			$("#input_tag_desc").val("");
		}
		*/
		let procs_id = $("#sel_proc option:selected").val();
		getProcTagList(procs_id);
	};

	let destDataList = [];
	function getDataSourceListLogic(data) {
		destDataList = data;
		let sel_id = "sel_dataSource";
		$("#" + sel_id + " option").remove();
		for (let obj of data) {
			$("#" + sel_id).append(`${'<option value="${obj.CD_ID}">${obj.CD_NM}</option>'}`);
		}
	};

	function getProcTagList(procs_id) {
		// 공정에 따른 태그 목록 조회
		let from = moment($("#strtDate").val() + " " + $("#strtTime").val()).format("YYYY-MM-DD HH:mm:ss");
		let to = moment($("#endDate").val() + " " + $("#endTime").val()).format("YYYY-MM-DD HH:mm:ss");
		if ((new Date(to) - new Date(from)) > 31 * 24 * 60 * 60 * 1000) {
			MsgBox("Info", "최대 조회기간은 1달입니다.");
			return;
		}
		__dataObj.setLoadingMask(true);
		let dest = $("#sel_dataSource option:selected").val();

		let obj = {
			procs_id: procs_id,
			from_dt: from,
			to_dt: to,
			is_revisn: "Y",
			dest: dest
		};
		$.ajax ({
			type: "POST",
			contentType: "application/json; charset=UTF-8",
			url: "getHstnTagList_hasRevisnlog",
			dataType: "json",
			cache: true,
			data: JSON.stringify(obj),
			success: function(res) {
				let data = new Array();

				// 태그 리스트 데이터 가공
				for (let tag of res) {
					data.push({
						TAGSN: tag.TAGSN,
						TAG_NM: tag.NODE_NM + "." + tag.TAG_ADDR,
						TAG_DESC: tag.TAG_DESC,
						IS_REVISN: tag.IS_REVISN
					});
				}
				__dataObj["tagDataList"] = data;
				__dataObj.setLoadingMask(false);
				searchTag(true);
			},
			error: function(e) {
				MsgBox("Info", "태그 목록 조회에 실패하였습니다.");
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

		onGridSelecting(ev.instance, rowKey, columnName);
		getDataQcHstyList();
	});

	__dataObj["dataGrid"] = new tui.Grid({
		el: document.getElementById("dataList"), // 컨테이너 엘리먼트
		scrollX: true,
		scrollY: true,
		minRowHeight: 30,
		rowHeight: 30,
		columns: [
			{
				header: "일시",
				name: "DATA_SAVE_DT",
				align: "center",
				width: getWidthByElementSize(250, 1238, $("#dataList")[0])
			}, {
				header: "보정전",
				name: "OLD_VALUE",
				align: "center",
				width: getWidthByElementSize(185, 1238, $("#dataList")[0])
			}, {
				header: "보정후",
				name: "LAST_VALUE",
				align: "center",
				width: getWidthByElementSize(185, 1238, $("#dataList")[0])
			}, {
				header: "보정시간",
				name: "REVISN_DT",
				align: "center",
				width: getWidthByElementSize(250, 1238, $("#dataList")[0])
			}, {
				header: "보정사유",
				name: "REVISN_RESN",
				align: "center",
				width: getWidthByElementSize(350, 1238, $("#dataList")[0]),
				renderer: {
					attributes: {
						style: function(props) {
							let value = props.value;
							//let backgroundColor = value.startsWith("개별") ? "#4ABBECF0" : "#F179E4F0";
							let backgroundColor = value.startsWith("개별") ? "#63E8F766" : "#EB464C66";
							return `background:\${backgroundColor};`;
						}
					}
				}
			}
		],
		columnOptions: {
			resizable: true
		}
	});

	__dataObj["dataGrid"].on("onBeforeEvent", function(a) {
		console.log(a);
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
			getWidthByElementSize(250, 1238, $("#dataList")[0]),
			getWidthByElementSize(185, 1238, $("#dataList")[0]),
			getWidthByElementSize(185, 1238, $("#dataList")[0]),
			getWidthByElementSize(250, 1238, $("#dataList")[0]),
			getWidthByElementSize(350, 1238, $("#dataList")[0])
		]);
		gridListResize("tag");
		gridListResize("data");
		__dataObj["resized"] = false;
	});

	// db 테이블에 등록된 전체 태그 목록 조회
	function getDataQcHstyList(isFirst) {
		if (__dataObj.getLoadingMask()) {
			return;
		}
		__dataObj["dataGrid"].resetData([]);

		if (isFirst) {
			return;
		}
		let from = moment($("#strtDate").val() + " " + $("#strtTime").val()).format("YYYY-MM-DD HH:mm:ss");
		let to = moment($("#endDate").val() + " " + $("#endTime").val()).format("YYYY-MM-DD HH:mm:ss");

		if ((new Date(to) - new Date(from)) > 31 * 24 * 60 * 60 * 1000) {
			MsgBox("Info", "최대 조회기간은 1달입니다.");
			return;
		}
		let dest = $("#sel_dataSource option:selected").val();

		if (checkFromToInvaildate(from, to)) {
			let selectedTag = __dataObj["tagGrid"].getRow(__dataObj["tagGrid"].getFocusedCell().rowKey);
			if (!!!selectedTag) {
				//MsgBox("Info", "선택된 태그가 없습니다.");
				return;
			}
			__dataObj.setLoadingMask(true);
			let obj = {
				"tag_nm": selectedTag.TAG_NM,
				"from_dt": from,
				"to_dt": to,
				dest: dest
			}

			$.ajax ({
				type: "POST",
				contentType: "application/json; charset=utf-8",
				cache: false,
				url: "getDataQcHstyList2",
				dataType: "json",
				data: JSON.stringify(obj),
				success: function(data) {
					// 데이터 오름차순 정렬 (DATA_SAVE_DT-일시)
					data.sort(function(a, b) {
						return new Date(a.DATA_SAVE_DT) - new Date(b.DATA_SAVE_DT); // 날짜로 비교
					});

					__dataObj["dataGrid"].resetData(data);
					gridListResize("data");
					__dataObj.setLoadingMask(false);
				}
			});
		} else {
			MsgBox("Info", "조회 기간을 확인해 주세요.");
			return;
		}
	};

	// 공정 태그 목록 검색 기능
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

		/*
		// 241119 삭제
		if ($("#checkIsRevisn").prop("checked")) {
			data = __dataObj["tagDataList"].filter(obj => obj.IS_REVISN == "Y");
		} else {
			data = __dataObj["tagDataList"];
		}
		*/

		__dataObj["tagGrid"].resetData(filterDesc);
		gridListResize("tag");
		gridListResize("data");
		getDataQcHstyList(true);

		/*
		// 첫 번째 데이터를 선택 => 241119 삭제
		if (filteredData.length > 0) {
			let $row = $("#tagList").jsGrid("rowByItem", filteredData[0]);
			$row.trigger("click");
		}
		*/
	};

	// 공정 태그 목록 엔터 키 검색
	function onEnterSearch(event) {
		if (event.keyCode === 13) { // 엔터키(Enter)가 눌렸을 때
			searchTag(); // 검색 함수 호출
		}
	};
	</script>
</body>
</html>