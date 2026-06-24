<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	language="java"%>
<%@ page session="true"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트 정보 관리</title>
<script type="text/javascript"
	src="<c:url value='resources/js/ckeditor/ckeditor.js'/>"></script>
<script>
	function fn_egov_init(id) {
		// 글쓰기 에디터 셋팅 (jsp 에서 textarea 선언 후 호출)
		let ckeditor_config = {
			height: 268,
			/* width:850, */
			fontSize_defaultLabel: "16px",
			filebrowserImageUploadUrl: "${pageContext.request.contextPath}/ckUploadImage", // 파일 업로드를 처리 할 경로 설정(CK필터).
			enterMode: CKEDITOR.ENTER_BR , // 엔터키를 <br> 로 적용함.
			shiftEnterMode: CKEDITOR.ENTER_P , // 쉬프트 + 엔터를 <p> 로 적용함.
			toolbarCanCollapse: true ,
			removePlugins: "elementspath", // DOM 출력하지 않음
			tabSpaces: 5,
			resize_enabled: false,
			toolbarGroups: [
				{
					"name": "basicstyles",
					"groups": ["basicstyles"]
				},
				/*
				{
					"name": "links",
					"groups": ["links"]
				},
				{
					"name": "document",
					"groups": ["mode"]
				},
				*/
				{
					"name": "insert",
					"groups": ["insert"]
				},
				{
					"name": "styles",
					"groups": ["styles"]
				},
				{
					"name": "about",
					"groups": ["about"]
				}
			],
			// Remove the redundant buttons from toolbar groups defined above.
			removeButtons: "Underline,Strike,Subscript,Superscript,Anchor,Styles,Specialchar,PasteFromWord,Image,Flash"
		};
		CKEDITOR.replace(id, ckeditor_config);
	};
</script>
<style>
.jsgrid-header-cell {
	text-wrap: nowrap;
}

#autoSaveTime {
	font-size: 0.85rem;
	color: #DD4444;
	float: right;
}
</style>
</head>
<body>
	<div class="main-screen">
		<p class="main-title">이벤트 정보 관리</p>
		<div class="main-contents-grid1" style="width: 100%; height: 100%;">
			<div class="main-search-group">
				<div class="main-contents-grid2"
					style="flex-wrap: wrap; width: 100%; justify-content: space-between;">
					<div class="com-search-unit"
						style="margin: 0; flex-wrap: wrap; row-gap: 0.65rem;">
						<p>이벤트 분류</p>
						<select id="evntSel"><option>-</option></select>
						<p>기간</p>
						<input id="date1" type="date" required pattern="\d{4}\d{2}\d{2}"
							max="9999-12-31" /> <input type="time" id="time1">~ <input
							id="date2" type="date" required pattern="\d{4}\d{2}\d{2}"
							max="9999-12-31" /> <input type="time" id="time2">
						<button id="btnSearch" class="find" onclick="search()"></button>
						<button id="btnExcel" class="excel_down" onclick="excelDownload()"></button>
					</div>
					<div class="com-search-unit" style="margin: 0; flex-wrap: wrap;">
					</div>
				</div>
			</div>
			<div class="main-contents-grid2" style="width: 100%; height: 100%;">
				<div class="main-contents-grid1 left-box"
					style="height: 100%; overflow-x: auto;">
					<div id="eventList" class="event-list" style="height: 93%;"></div>
				</div>
				<div class="snb_split_area"></div>
				<div class="main-contents-grid1 right-box">
					<div id="titleEvntAdd" class="main-contents-grid2"
						style="padding: 0.25rem; justify-content: space-between;">
						<h2 style="display: inline-flex; align-items: center;">이벤트 등록</h2>
					</div>
					<div id="titleEvntModify" class="main-contents-grid2"
						style="display: none; padding: 0.25rem; justify-content: space-between;">
						<h2 id="modyTitle">이벤트 상세</h2>
					</div>
					<div class=" main-contents-grid1" style="height: 100%;">
						<div class="back-box" style="height: 98%;">
							<form id="atchForm" class="main-contents-grid1"
								style="row-gap: 0.95rem;" method="post" onsubmit="return false;"
								enctype="multipart/form-data">
								<input type="hidden" name="evnt_id" /> <input type="hidden"
									name="atch_file_id" />
								<div class="main-contents-grid2"
									style="column-gap: 2rem; flex-wrap: wrap; justify-content: space-between;">
									<div class="main-contents-grid1">
										<h2>
											이벤트 분류<span id="autoSaveTime"></span>
										</h2>
										<div id="evntSeBtnBox"
											style="display: flex; column-gap: 0.6rem;">
											<input type="hidden" name="evnt_se" id="evntSe" /> <input
												type="hidden" name="evnt_se_old" id="evntSe_old" />
										</div>
									</div>
									<div class="main-contents-grid1"
										style="width: clamp(8rem, 100%, 11.5rem);">
										<h2>근무자</h2>
										<input type="text" name="wrkr" />
									</div>
								</div>
								<div class="main-contents-grid1">
									<div class="main-contents-grid2"
										style="flex-wrap: wrap; justify-content: space-between;">
										<div class="main-contents-grid2"
											style="align-items: center; column-gap: 0.4rem;">
											<h2 style="align-content: center;">추가 설정</h2>
											<img class="slide-down" id="btnSlideSetting"
												onclick="toggleBox(this, 'settingBox');">
											<p id="addSettingTxt" style="align-content: center;"></p>
										</div>
										<div id="titleEvntAdd1" class="main-contents-grid2"
											style="justify-content: space-between;">
											<button class="add" onclick="showAddEvntForm('add')">
												<img />
											</button>
											<button class="save" onclick="onSaveEvntInfo(true);"></button>
										</div>
										<div id="titleEvntModify1" class="main-contents-grid2"
											style="display: none; justify-content: space-between;">
											<button class="add" onclick="showAddEvntForm('add')">
												<img />
											</button>
											<button class="save" onclick="onUpdateEvntInfo(true);"></button>
											<button class="del" onclick="onDeleteEvntInfo();"></button>
										</div>
									</div>
									<div id="settingBox"
										style="padding: 0.65rem; border: 1px solid #DADAE2; display: none;">
										<div class="main-contents-grid1" style="row-gap: 1.25rem;">
											<div class="main-contents-grid1">
												<div class="main-contents-grid2">
													<h2>공정 분류</h2>
												</div>
												<div class="btn-group" id="BTNGRP_P"></div>
												<input type="hidden" name="procs_id">
											</div>
											<div class="main-contents-grid1">
												<div class="main-contents-grid2">
													<h2>설비 분류</h2>
												</div>
												<div class="btn-group" id="BTNGRP_F"></div>
												<input type="hidden" name="fclt_id">
											</div>
											<div class="main-contents-grid1">
												<div class="main-contents-grid2">
													<h2>설비 상세 분류</h2>
												</div>
												<div class="btn-group" id="BTNGRP_FD"
													style="min-height: 3.15rem;"></div>
												<input type="hidden" name="fclt_dtl_id">
											</div>
										</div>
									</div>
								</div>
								<div class="main-contents-grid1">
									<div class="main-contents-grid1" style="flex-wrap: wrap;">
										<div class="main-contents-grid2"
											style="justify-content: space-between;">
											<div class="main-contents-grid2"
												style="align-items: center; column-gap: 0.4rem;">
												<h2 id="titleEvntCn" style="align-content: center;">이벤트
													내용</h2>
												<img class="slide-up" id="btnSlideEvntCn"
													onclick="toggleBox(this, 'evntCnBox');">
											</div>
											<div class="main-contents-grid2">
												<h2 style="align-content: center;">일시</h2>
												<input type="date" id="strtDate" max="9999-12-31" /> <input
													type="time" id="strtTime" /> <input type="hidden"
													name="bgng_dt" /> <input type="hidden" name="bgng_dt_old" />
											</div>
										</div>
										<div id="evntCnBox" class="main-contents-grid1">
											<textarea name="evnt_cn" id="evnt_cn"></textarea>
										</div>
									</div>
									<div class="main-contents-grid1" style="flex-wrap: wrap;">
										<div class="main-contents-grid2"
											style="justify-content: space-between;">
											<div class="main-contents-grid2"
												style="align-items: center; column-gap: 0.4rem;">
												<h2 style="align-content: center;">조치 내용</h2>
												<img class="slide-up" id="btnSlideEvntCn2"
													onclick="toggleBox(this, 'evntCn2Box');">
											</div>
											<div class="main-contents-grid2">
												<h2 style="align-content: center;">일시</h2>
												<input type="date" id="endDate" max="9999-12-31" /> <input
													type="time" id="endTime" /> <input type="hidden"
													name="end_dt" />
											</div>
										</div>
										<div id="evntCn2Box" class="main-contents-grid1">
											<textarea name="evnt_cn2" id="evnt_cn2"></textarea>
										</div>
									</div>
								</div>
								<div class="main-contents-grid1">
									<h2>
										이미지 / 오디오
										<!-- <button type="button" id="addFileRow" class="btn-add-file-row" onclick="addNewFileRow();"> + </button> -->
									</h2>
									<div id="fileContainer" class="file-container">
										<div class="file-row">
											<div class="file-group">
												<input type="text" id="fileName1" readonly
													placeholder="첨부파일1"> <label for="fileInput1"
													class="file-label">파일찾기</label> <input type="file"
													id="fileInput1" name="file1" data-file-id="1"
													onchange="handleFileSelect(this);" style="display: none;">
											</div>
											<button type="button" class="btn-preview" data-file-id="1"
												onclick="handleFilePreview(this);">미리보기</button>
										</div>
										<div class="file-row">
											<div class="file-group">
												<input type="text" id="fileName2" readonly
													placeholder="첨부파일2"> <label for="fileInput2"
													class="file-label">파일찾기</label> <input type="file"
													id="fileInput2" name="file2" data-file-id="2"
													onchange="handleFileSelect(this);" style="display: none;">
											</div>
											<button type="button" class="btn-preview" data-file-id="2"
												onclick="handleFilePreview(this);">미리보기</button>
										</div>
										<input type="hidden" name="fileCnt" value="0">
									</div>
									<input type="hidden" name="evnt_id" value=""> <input
										type="hidden" name="atch_file_id" value="">
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="previewDlg">
		<img id="img">
		<audio id="audio" src="" controls>
			<!-- <source id="audioSource" src="">Your browser does not support the audio element. -->
		</audio>
		<input type="file" name="previewFile" />
	</div>
	<script>
		const __dataObj = {
			"startX": 0,
			"startWidth": 0,
			"changeWidth": 0,
			"eventListMinWidth": 50,
			"eventListMaxWidth": 500,
			"orgGridData" : null,
			"evntSeData" : null,
			"evntCn" : "",
			"evntCn2" : "",
			"rowData" : null
		};

		const __autoSaveDataObj = {
			"isAutoSaveMode" : false,
			"eventCnChangeEvent" : null,
			"eventCn2ChangeEvent" : null,
			"autoSaveIntervalFunc" : null,
			"autoSaveInterval" : 5 * 60 * 1000,
		};

		const __observeAutoSave = new Proxy(__autoSaveDataObj, {
			get(target, prop, val) {
				return target[prop];
			},
			set(target, prop, val) {
				if (prop == "isAutoSaveMode") {
					if (target[prop] != val) {
						target[prop] = val;
						if (val == true) {
							if (__autoSaveDataObj["autoSaveIntervalFunc"]) {
								clearInterval(__autoSaveDataObj["autoSaveIntervalFunc"]);
							}
							let evntId = document.querySelector("input[name='evnt_id']");
							let saveTimeEmt = document.querySelector("#autoSaveTime");
							if (saveTimeEmt) {
								setTimeout(() => {
									saveTimeEmt.textContent = "";
								}, 3000);
							}
							if (evntId.value) {
								__autoSaveDataObj["autoSaveIntervalFunc"] = setInterval(() => {
									onUpdateEvntInfo(false);
									__dataObj["evntCn"] = CKEDITOR.instances.evnt_cn.getData();
									__dataObj["evntCn2"] = CKEDITOR.instances.evnt_cn2.getData();
									let gridRowData = $("#eventList").jsGrid("option", "data").find(obj => obj.evnt_id);
									__dataObj["rowData"].evnt_cn = __dataObj["evntCn"];
									__dataObj["rowData"].evnt_cn2 = __dataObj["evntCn2"];
									$("#eventList").jsGrid("updateItem", gridRowData, __dataObj["rowData"]);
									let now = new Date();
									if (saveTimeEmt) {
										let hours = String(now.getHours()).padStart(2, "0");
										let minutes = String(now.getMinutes()).padStart(2, "0");
										let seconds = String(now.getSeconds()).padStart(2, "0");
										saveTimeEmt.textContent = hours + ":" + minutes + ":" + seconds + " 자동저장";
									}
									__observeAutoSave.isAutoSaveMode = false;
								}, __autoSaveDataObj["autoSaveInterval"]);
							} else {
								__autoSaveDataObj["autoSaveIntervalFunc"] = setInterval(() => {
									localStorage.tempEvntCn = CKEDITOR.instances.evnt_cn.getData();
									localStorage.tempEvntCn2 = CKEDITOR.instances.evnt_cn2.getData();
									let now = new Date();
									if (saveTimeEmt) {
										let hours = String(now.getHours()).padStart(2, "0");
										let minutes = String(now.getMinutes()).padStart(2, "0");
										let seconds = String(now.getSeconds()).padStart(2, "0");
										saveTimeEmt.textContent = hours + ":" + minutes + ":" + seconds + " 임시저장";
									}
									__observeAutoSave.isAutoSaveMode = false;
								}, __autoSaveDataObj["autoSaveInterval"]);
							}
						} else {
							clearInterval(__autoSaveDataObj["autoSaveIntervalFunc"]);
							__autoSaveDataObj["autoSaveIntervalFunc"] = null;
						}

						return true;
					}

					return false;
				}
			}
		});

		const s_PageSize = 50; //13; // 스크롤 없게
		// 처음 페이지 로드시
		window.onload = async function() {
			// CKEDITOR
			fn_egov_init("evnt_cn");
			fn_egov_init("evnt_cn2");
			// 그리드 임시 데이터 조회
			initGrid();
			init();
		};

		function getAtchFileList(atch_file_id) {
			return new Promise((resolve, reject) => {
			$.ajax ({
					type: "POST",
					cache: false,
					url: "getAtchFileList",
					data: { atch_file_id: atch_file_id },
					success: function(files) {
						resolve(files);
					}, error: function(e) {
						console.error(e);
						reject(e); // 오류 발생 시 reject 호출
					}
				});
			});
		};

		function initGrid() {
			// 이벤트 정보 jsGrid 설정
			$("#eventList").jsGrid({
				width: "max(1050px, 100%)",
				height: "97.5%",
				noDataContent: "No data.",
				filtering: true,
				autoload: true,
				editing: false,
				sorting: false,
				paging: true,
				pageSize: s_PageSize,
				fields: [
					{
						name: "evnt_se_nm",
						type: "text",
						width: 95,
						title: "이벤트 분류",
						align: "center",
						editing: false,
						filtering: false,
						cellRenderer: function(value, item) {
							let result = "<div style='width: 100%; max-width: 7rem; display: flex; justify-content: center; color: #FFFFFF; ";
							switch (item.evnt_se) {
								case "1": result += "background: #FF5050;' title='" + value + "'>" + value; break;
								case "2": result += "background: #83A603;' title='" + value + "'>" + value; break;
								case "3": result += "background: #00B0F0;' title='" + value + "'>" + value; break;
							}
							/*
							let result = "<div style='width: 100%; display: flex; justify-content: center;'>";
							switch (item.evnt_se) {
								case "1": result += "<div style='width: 20px; height: 20px; background: #FF5050;' title='" + value + "'></div>"; break;
								case "2": result += "<div style='width: 20px; height: 20px; background: #83A603;' title='" + value + "'></div>"; break;
								case "3": result += "<div style='width: 20px; height: 20px; background: #00B0F0;' title='" + value + "'></div>"; break;
							}
							*/
							result += "</div>";
							let jqTd = $("<td>");
							jqTd.css("justify-items", "center");
							jqTd.html(result);
							return jqTd;
						}
					}, {
						name: "evnt_categorize",
						type: "text",
						width: 110,
						title: "분류",
						align: "center",
						editing: false,
						itemTemplate: function(value, row) {
							let c_procs = row.procs_nm ?? "";
							let c_fclt = row.fclt_nm ?? "";
							let c_fclt_dtl = row.fclt_dtl_nm ?? "";

							let result = "";
							if (c_procs.length > 0) {
								result = c_procs;
							}

							if (c_fclt.length > 0) {
								if (result != "") {
									result += " > ";
								}
								result += c_fclt;
							}

							if (c_fclt_dtl.length > 0) {
								if (result != "") {
									result += " > ";
								}
								result += c_fclt_dtl;
							}
							let eventId = row.evnt_id + "_categorize"
							let jsonStr = JSON.stringify({evnt_id: eventId, evnt_cn: result});
							return `<div style="position: relative;">
							<div style="width: 100%; height: 100%; white-space: nowrap; text-overflow: ellipsis; overflow: hidden;" onmouseenter='showTooltipEvntCn(\${jsonStr});' onmouseleave='hideTooltipEvntCn("\${eventId}");'>\${result}</div>
							<div class="tooltip-text" id="tooltip_text_\${eventId}" style="white-space: nowrap; z-index: 1;"></div>
							</div>`;
						}
					}, {
						name: "evnt_cn",
						type: "text",
						width: 200,
						title: "이벤트 내용",
						align: "left",
						editing: false,
						headerTemplate: function() {
							let emtStr = `이벤트 내용
								<div class="filter-toggle-group">
									<input id="cbxFilterToggle" type="checkbox" checked="checked" />
									<label class="btnFilterToggle" for="cbxFilterToggle" title="필터 ON/OFF" style="animation:none;"></label>
								</div>`
							return emtStr;
						},
						itemTemplate: function(value, row) {
							let firstLine = value.split("<br />")[0];
							let jsonStr = JSON.stringify({evnt_id: row.evnt_id, evnt_cn: row.evnt_cn});
							return `<div style="position: relative;">
							<div style="width: 100%; height: 100%; white-space: nowrap; text-overflow: ellipsis; overflow: hidden;" onmouseenter='showTooltipEvntCn(\${jsonStr});' onmouseleave='hideTooltipEvntCn("\${row.evnt_id}");'>\${firstLine}</div>
							<div class="tooltip-text" id="tooltip_text_\${row.evnt_id}" style="z-index: 1;"></div>
							</div>`;
						}
					}, {
						name: "evnt_cn2",
						type: "text",
						width: 200,
						title: "조치 내용",
						align: "left",
						editing: false,
						itemTemplate: function(value, row) {
							if (value) {
								let firstLine = value.split("<br />")[0];
								let eventId = row.evnt_id + "_cn2";
								let jsonStr = JSON.stringify({evnt_id: eventId, evnt_cn: row.evnt_cn2});
								return `<div style="position: relative;">
								<div style="width: 100%; height: 100%; white-space: nowrap; text-overflow: ellipsis; overflow: hidden;" onmouseenter='showTooltipEvntCn(\${jsonStr});' onmouseleave='hideTooltipEvntCn("\${eventId}");'>\${firstLine}</div>
								<div class="tooltip-text" id="tooltip_text_\${eventId}" style="z-index: 1;"></div>
								</div>`;
							} else {
								return `<div></div>`;
							}
						}
					},
					/*
					{
						name: "procs_nm", type: "text", width: 100, title: "공정명", align: "center", visible: false,
						itemTemplate: function(value, row) {
							return value??"-";
						}
					},
					{
						name: "fclt_nm", type: "text", width: 100, title: "시설명", align: "center", visible: false,
						itemTemplate: function(value, row) {
							return value??"-";
						}
					},
					{
						name: "fclt_dtl_nm", type: "text", width: 100, title: "시설 상세", align: "center", visible: false,
						itemTemplate: function(value, row) {
							return value??"-";
						}
					},
					{
						name: "wrkr", type: "text", width: 100, title: "근무자", align: "center",
						itemTemplate: function(value, row) {
							return value??"-";
						}
					},
					*/
					{
						name: "bgng_dt",
						type: "text",
						width: 150,
						title: "시작 일시",
						align: "center",
						editing: false,
					}, {
						name: "end_dt",
						type: "text",
						width: 150,
						title: "종료 일시",
						align: "center",
						editing: false,
					}, {
						name: "attachment",
						type: "text",
						width: 95,
						title: "첨부파일",
						align: "left",
						editing: false,
						filtering: false,
						filterTemplate: function() {
							let btnGroup = document.createElement("div");
							btnGroup.style.width = "100%";
							btnGroup.style.height = "100%";
							btnGroup.style.textAlign = "center";

							let btnSearchFilter = document.createElement("button");
							btnSearchFilter.id = "btnEventListSearchFilter";
							btnSearchFilter.classList.add("btnSearchFilter");
							btnSearchFilter.title = "필터 검색";
							btnSearchFilter.setAttribute("onclick", "searchFilter()");
							btnGroup.append(btnSearchFilter);

							let btnCelarFilter = document.createElement("button");
							btnCelarFilter.id = "btnEventListClearFilter";
							btnCelarFilter.classList.add("btnClearFilter");
							btnCelarFilter.title = "필터 초기화";
							btnCelarFilter.setAttribute("onclick", "clearFilter()");
							btnGroup.append(btnCelarFilter);
							return btnGroup.outerHTML;
						},
						cellRenderer: function(value, item) {
							let emtId = this._grid._container[0].id;
							document.querySelectorAll(`#\${emtId} .jsgrid-header-cell`).forEach(function(th, idx) {
								let headerWidth = th.style.width;
								document.querySelectorAll(`#\${emtId} .jsgrid-cell:nth-child(\${idx + 1})`).forEach(function(td) {
									td.style.width = headerWidth;
								});
							});
							return $("<td>").html(value);
						}
					}
				],
				rowDoubleClick: function(args) {
					// 선택된 row 표시
					$("#eventList .jsgrid-table tr").removeClass("jsgrid-highlight-row");
					$(args.event.currentTarget).addClass("jsgrid-highlight-row");
				},
				rowClick: function(args) {
					$("#eventList .jsgrid-table tr").removeClass("jsgrid-highlight-row");
					if (args.event.target.className != "evnt-atch-file-icon") {
						$("#titleEvntAdd").hide();
						$("#titleEvntAdd1").hide();
						$("#titleEvntModify").show();
						$("#titleEvntModify1").show();
						showAddEvntForm("rowclick");
						// 선택된 로우의 데이터 가져오기
						const rowData = args.item;
						__dataObj["rowData"] = rowData;
						$("input[name='evnt_id']").val(rowData.evnt_id);
						$("input[name='atch_file_id']").val(rowData.atch_file_id);
						$("#evnt" + rowData.evnt_se).addClass("active");
						$("#evntSe").val(rowData.evnt_se);
						$("#evntSe_old").val(rowData.evnt_se);
						$("input[name='wrkr']").val(rowData.wrkr);

						document.querySelector("#strtDate").disabled = false;
						document.querySelector("#strtTime").disabled = false;
						document.querySelector("#endDate").disabled = false;
						document.querySelector("#endTime").disabled = false;
						let bgng_dt = (rowData.bgng_dt).split(" ");
						let end_dt = (rowData.end_dt).split(" ");
						$("#strtDate").val(bgng_dt[0] || "");// 시작일시
						$("#strtTime").val(bgng_dt[1] || "");// 시작시간
						$("#endDate").val(end_dt[0] || "");// 종료일시
						$("#endTime").val(end_dt[1] || "");// 종료시간
						$("input[name='bgng_dt_old']").val(rowData.bgng_dt);
						let settingTxt = "";

						if (!!rowData.procs_id) {
							$("#BTNGRP_P #" + rowData.procs_id).trigger("click");
							settingTxt += rowData.procs_nm;
						}
						if (!!rowData.fclt_id) {
							$("#BTNGRP_F #" + rowData.fclt_id).addClass("click");
							$("input[name='fclt_id']").val(rowData.fclt_id);
							if (settingTxt != "") {
								settingTxt += " > ";
							}
							settingTxt += rowData.fclt_nm;
						}

						if (!!rowData.fclt_id && !!!rowData.fclt_dtl_id) {
							// 설비 분류만 선택하고 설비 상세 분류는 선택 안했을 때
							onChangeFclt(rowData.fclt_id);
						} else if (!!rowData.fclt_id && !!rowData.fclt_dtl_id) {
							onChangeFclt(rowData.fclt_id, rowData.fclt_dtl_id);
							if (settingTxt != "") {
								settingTxt += " > ";
							}
							settingTxt += rowData.fclt_dtl_nm;
						}

						let evntSeData = __dataObj["evntSeData"].find(obj => obj.CD_ID == rowData.evnt_se);
						let evntSeTitle = " 내용";
						if (evntSeData && evntSeData.CD_NM) {
							let evntSeNm = (evntSeData.CD_NM || "");
							if (evntSeNm.includes("/")) {
								evntSeTitle = evntSeNm.split("/")[0] + evntSeTitle;
							} else {
								evntSeTitle = evntSeNm.slice(2) + evntSeTitle;
							}
						} else {
							evntSeTitle = "이벤트" + evntSeTitle;
						}
						document.querySelector("#titleEvntCn").innerText = evntSeTitle;
						__dataObj["evntCn"] = rowData.evnt_cn;
						__dataObj["evntCn2"] = rowData.evnt_cn2;
						setTimeout(function() {
							/*
							if (rowData.evnt_cn || rowData.evnt_cn2) {
								$("#btnSlideEvntCn").removeClass("slide-down");
								$("#btnSlideEvntCn").addClass("slide-up");
								$("#evntCnBox").show();
							}
							*/
							if (!document.querySelector("#evntCnBox").style.display) {
								CKEDITOR.instances.evnt_cn.updateElement();
								CKEDITOR.instances.evnt_cn.insertHtml(__dataObj["evntCn"]);
								__dataObj["evntCn"] = CKEDITOR.instances.evnt_cn.getData();
							}
							/*
							if (rowData.evnt_cn || rowData.evnt_cn2) {
								$("#btnSlideEvntCn2").removeClass("slide-down");
								$("#btnSlideEvntCn2").addClass("slide-up");
								$("#evntCn2Box").show();
							}
							*/
							if (!document.querySelector("#evntCn2Box").style.display) {
								CKEDITOR.instances.evnt_cn2.updateElement();
								CKEDITOR.instances.evnt_cn2.insertHtml(__dataObj["evntCn2"]);
								__dataObj["evntCn2"] = CKEDITOR.instances.evnt_cn2.getData();
							}
						}, 1);

						// 첨부파일 처리
						if (!!rowData.fileInfo_1) {
							isSetting = true;
							let file_info = rowData.fileInfo_1;
							$("#fileName1").val(file_info.orgnl_file_nm);

							let blob = b64toBlob(file_info.byte_img, file_info.file_type);
							let blobUrl = URL.createObjectURL(blob);
							const file = new File([blob], file_info.orgnl_file_nm, {type: file_info.file_type});
							const fileList = new DataTransfer();
							fileList.items.add(file);
							document.getElementById("fileInput1").files = fileList.files;
						} else {
							$("#fileName1").val("첨부파일1");
						}

						if (!!rowData.fileInfo_2) {
							isSetting = true;
							let file_info = rowData.fileInfo_2;
							$("#fileName2").val(file_info.orgnl_file_nm);

							let blob = b64toBlob(file_info.byte_img, file_info.file_type);
							let blobUrl = URL.createObjectURL(blob);
							const file = new File([blob], file_info.orgnl_file_nm, {type: file_info.file_type});
							const fileList = new DataTransfer();
							fileList.items.add(file);
							document.getElementById("fileInput2").files = fileList.files;
						} else {
							$("#fileName2").val("첨부파일2");
						}

						if (settingTxt != "") {
							$("#addSettingTxt").text(settingTxt);
							$("#modyTitle").text(rowData.evnt_se_nm + " > " + settingTxt);
						}
						let row = $("#eventList").jsGrid("rowByItem", rowData);
						row.addClass("jsgrid-highlight-row");
					}
				},
				onDataLoading: function(args) {
					if (args.grid.data.length == 0) {
						// 오른쪽 이벤트 추가로 변경
						showAddEvntForm("init");
					}
				},
				onDataLoaded: function(args) {
					let data = args.data;
					if (__dataObj["orgGridData"] == null) {
						__dataObj["orgGridData"] = data;
					}
					let selectedRowIndex = 0;
					for (let idx in data) {
						let obj = data[idx];
						if (!!obj.atch_file_id) {
							// 첨부파일
							getAtchFileList(obj.atch_file_id).then((files) => {
								let appendTxt = "";
								for (let file of files) {
									obj["fileInfo_"+file.file_sn] = {orgnl_file_nm: file.orgnl_file_nm, byte_img: file.byte_img, file_type: file.file_type};

									let file_type = obj["fileInfo_"+file.file_sn].file_type;
									let json = JSON.stringify(file);
									if (file_type.includes("audio")) {
										appendTxt += `<a onclick='openPreviewDlg(\${json});''>
											<img src="resources/images/view/ai/icnSound.png" 
											class="evnt-atch-file-icon" title="\${file.orgnl_file_nm}"/></a>`;
									} else if (file_type.includes("image")) {
										appendTxt += `<a onclick='openPreviewDlg(\${json});''> 
											<img src="resources/images/view/ai/icnImage.png" 
											class="evnt-atch-file-icon" title="\${file.orgnl_file_nm}"/></a>`;
									}
								}
								obj.attachment = "<div class='evnt-atch-file-div'>"+appendTxt+"</div>";
								$("#eventList").jsGrid("updateItem", obj);
							});
						}
						if (obj.selected_row && (obj.selected_row == true || obj.selected_row.toLowerCase() == "true")) {
							selectedRowIndex = idx;
						}
					}
					if (data.length > 0) {
						let $row = $("#eventList").jsGrid("rowByItem", data[selectedRowIndex]);
						$row.trigger("click");
					} else {
						showAddEvntForm("add");
						//MsgBox("Info", "조회 결과가 없습니다");
					}
				},
				controller: {
					loadData: function(filter) {
						// Filter 검색일때
						if (!Object.keys(filter).includes("selected_row")) {
							if (__dataObj["orgGridData"] != null && __dataObj["orgGridData"].length > 0) {
								let gridData = __dataObj["orgGridData"].map(obj => ({...obj}));
								gridData = gridData.filter(obj => {
									let isFilteringData = true;
									if (filter.evnt_categorize) {
										let c_procs = obj.procs_nm ?? "";
										let c_fclt = obj.fclt_nm ?? "";
										let c_fclt_dtl = obj.fclt_dtl_nm ?? "";
	
										let result = "";
										if (c_procs.length > 0) {
											result = c_procs;
										}
	
										if (c_fclt.length > 0) {
											if (result != "") {
												result += " > ";
											}
											result += c_fclt;
										}
	
										if (c_fclt_dtl.length > 0) {
											if (result != "") {
												result += " > ";
											}
											result += c_fclt_dtl;
										}
										isFilteringData = isFilteringData && (result || "").includes(filter.evnt_categorize);
									}
									isFilteringData = isFilteringData && (obj.evnt_cn || "").includes(filter.evnt_cn);
									isFilteringData = isFilteringData && (obj.evnt_cn2 || "").includes(filter.evnt_cn2);
									isFilteringData = isFilteringData && (obj.bgng_dt || "").includes(filter.bgng_dt);
									isFilteringData = isFilteringData && (obj.end_dt || "").includes(filter.end_dt);
									return isFilteringData;
								});
								initAddEvntForm();
								return gridData;
							}
						} else {
							__dataObj["orgGridData"] = null;
							return $.ajax ({
								type: "POST",
								cache: false,
								url: "getEvntList",
								data: filter,//JSON.stringify(filter),
							});
						}
					},
					updateItem: function(item) {
						setTimeout(function() {
							document.querySelectorAll("#eventList .jsgrid-header-cell").forEach(function(th, idx) {
								let headerWidth = th.style.width;
								document.querySelectorAll(`#eventList .jsgrid-cell:nth-child(\${idx + 1})`).forEach(function(td) {
									td.style.width = headerWidth;
								});
							});
						}, 0);
						return item;
					}
				}
			});

			$("#eventList .jsgrid-header-cell").resizable({
				handles: "e",
				minWidth: __dataObj["eventListMinWidth"],
				maxWidth: __dataObj["eventListMaxWidth"],
				resize: function(event, ui) {
					/*
					let emt = ui.element[0];
					while (emt.id != "tagList") {
						if (emt.tagName.toUpperCase() == "BODY") {
							break;
						}
						emt = emt.parentElement;
					}
					let newWidth = ui.size.width;
					*/
					__dataObj["changeWidth"] = Number(__dataObj["startWidth"]) + (event.pageX - __dataObj["startX"]);
					if (__dataObj["changeWidth"] <= __dataObj["eventListMinWidth"]) {
						__dataObj["changeWidth"] = __dataObj["eventListMinWidth"];
					} else if (__dataObj["changeWidth"] >= __dataObj["eventListMaxWidth"]) {
						__dataObj["changeWidth"] = __dataObj["eventListMaxWidth"];
					}
					this.style.width = __dataObj["changeWidth"];
					let index = this.cellIndex;
					document.querySelectorAll(`#eventList .jsgrid-cell:nth-child(\${index + 1})`).forEach(td => {
						td.style.width = __dataObj["changeWidth"];
					});
					//$(`#\${emt.id} .jsgrid-cell:nth-child(\${index + 1})`).css("width", newWidth);
				},
				start: function(event, ui) {
					__dataObj["startWidth"] = this.style.width.replace("px", "");
					__dataObj["startX"] = event.pageX;
				},
				stop: function(event, ui) {
					let index = this.cellIndex;
					document.querySelectorAll(`#eventList .jsgrid-cell:nth-child(\${index + 1})`).forEach(td => {
						td.style.width = __dataObj["changeWidth"];
					});
				}
			});
		};

		function searchFilter() {
			$("#eventList").jsGrid("loadData");
		};

		function clearFilter() {
			$("#eventList").jsGrid("clearFilter");
		};

		function showTooltipEvntCn(row) {
			// 이벤트 내용에 마우스 HOVER 이벤트
			const tooltip = document.getElementById("tooltip_text_" + row.evnt_id);
			tooltip.innerHTML = row.evnt_cn;
			tooltip.style.display = "block";
		};

		function hideTooltipEvntCn(evnt_id) {
			// 이벤트 내용에 마우스 HOVER 이벤트
			const tooltip = document.getElementById("tooltip_text_" + evnt_id);
			tooltip.style.display = "none";
		};

		async function init() {
			timeOnBlurEvent();
			// 조회 기간 설정
			let start = new Date();
			start.setHours(0);
			let end = new Date();

			setDateTimeNoLimit($("#date1"), $("#time1"), start);
			setDateTimeNoLimit($("#date2"), $("#time2"), end);
			// 공정 목록 조회
			let procsList = await getProcInfoList(undefined, "data", "Y");
			$("#BTNGRP_P button").remove();
			for (let obj of procsList) {
				$("#BTNGRP_P").append("<button id='" + obj.PROCS_ID + "' class='btn-tag' title='" + obj.PROCS_NM + "'>" + obj.PROCS_NM + "</button>");
			}

			document.getElementById("BTNGRP_P").querySelectorAll(".btn-tag").forEach(button => {
				button.addEventListener("click", function() {
				// click class 삭제
					if (this.classList.contains("click")) {
						this.classList.remove("click");
						$("input[name='procs_id']").val("");
						AddSettingText();
						return;
					}
					this.parentElement.childNodes.forEach(btn => btn.classList.remove("click"));
					this.classList.add("click");
					$("input[name='procs_id']").val(this.id);
					AddSettingText();
				});
			});

			let fcltList = await getFcltInfoList();
			$("#BTNGRP_F button").remove();

			for (let obj of fcltList) {
				$("#BTNGRP_F").append("<button id='" + obj.CD_ID + "' class='btn-tag' title='" + obj.CD_NM + "'>" + obj.CD_NM + "</button>");
			}

			document.getElementById("BTNGRP_F").querySelectorAll(".btn-tag").forEach(fclt_btn => {
				fclt_btn.addEventListener("click", function() {
					// click class 삭제
					if (this.classList.contains("click")) {
						this.classList.remove("click");
						$("input[name='fclt_id']").val("");
						AddSettingText();
						return;
					}
					this.parentElement.childNodes.forEach(btn => btn.classList.remove("click"));
					this.classList.add("click");
					$("input[name='fclt_id']").val(this.id);
					onChangeFclt(this.id);
					AddSettingText();
				});
			});

			// 이벤트 분류 조회
			let evnt_data = await getEvntInfoList();
			__dataObj["evntSeData"] = evnt_data;
			$("#evntSel option").remove();
			$("#evntSel").append("<option value='*'>전체</option>");
			for (let obj of evnt_data) {
				$("#evntSel").append("<option value='" + obj.CD_ID + "'>" + obj.CD_NM + "</option>");
			}

			$("#evntSeBtnBox button").remove();
			$("#evntSe").val("");
			for (let obj of evnt_data) {
				$("#evntSeBtnBox").append("<button class='btn-evnt evnt" + obj.CD_ID + "' id='evnt" + obj.CD_ID + "'>" + obj.CD_NM + "</button>");
			}

			document.querySelectorAll(".btn-evnt").forEach((v, i) => {
				v.addEventListener("click", function(e){
					this.parentElement.childNodes.forEach((btn) => { if (btn.nodeName == "BUTTON") btn.classList.remove("active") });

					$("#evntSe").val((e.target.id).replace("evnt", ""));
					e.target.classList.add("active");
					toggleBox(btnSlideSetting, "settingBox", true);
					let evntSeData = __dataObj["evntSeData"].find(obj => obj.CD_ID == $("#evntSe").val());
					let evntSeTitle = " 내용";
					if (evntSeData && evntSeData.CD_NM) {
						let evntSeNm = (evntSeData.CD_NM || "");
						if (evntSeNm.includes("/")) {
							evntSeTitle = evntSeNm.split("/")[0] + evntSeTitle;
						} else {
							evntSeTitle = evntSeNm.slice(2) + evntSeTitle;
						}
					} else {
						evntSeTitle = "이벤트" + evntSeTitle;
					}
					document.querySelector("#titleEvntCn").innerText = evntSeTitle;
				});
			});

			document.querySelector("#cbxFilterToggle").onchange = function(ev) {
				let btnToggle = document.querySelector("#cbxFilterToggle + .btnFilterToggle");
				if (btnToggle && btnToggle.style.animation) {
					btnToggle.style.animation = "";
				}
				$("#eventList").jsGrid("option", "filtering", this.checked);
			};

			search();
		};

		function AddSettingText() {
			let c_procs = document.getElementById("BTNGRP_P").querySelectorAll(".btn-tag.click");
			let c_fclt = document.getElementById("BTNGRP_F").querySelectorAll(".btn-tag.click");
			let c_fclt_dtl = document.getElementById("BTNGRP_FD").querySelectorAll(".btn-tag.click");
			let procs_nm = "", fclt_nm ="";

			let result = "";
			if (c_procs.length > 0) {
				procs_nm = c_procs[0].innerText;
				result = procs_nm;
			}

			if (c_fclt.length > 0) {
				if (procs_nm != "") {
					result += " > ";
				}
				fclt_nm = c_fclt[0].innerText;
				result += fclt_nm;
			}

			if (c_fclt_dtl.length > 0) {
				if (fclt_nm != "") {
					result += " > ";
				}
				result += c_fclt_dtl[0].innerText;
			}

			$("#addSettingTxt").text(result);
		};

		function search(evnt_id) {
			initAddEvntForm();

			let obj = {
				evnt_se: $("#evntSel option:selected").val(),
				bgng_dt: ($("#date1").val()).replaceAll("-", "") + ($("#time1").val()).replaceAll(":", ""),
				end_dt: ($("#date2").val()).replaceAll("-", "") + ($("#time2").val()).replaceAll(":", ""),
				selected_row: (!!evnt_id ? evnt_id : "")
			};

			$("#eventList").jsGrid("loadData", obj);
		};

		function initAddEvntForm(type) {
			if (!type) {
				type = "rowclick";
			}
			$("#eventList .jsgrid-table tr").removeClass("jsgrid-highlight-row");
			$("input[name='evnt_id']").val("");
			$("input[name='atch_file_id']").val("");

			// 자동저장 관련
			__dataObj["rowData"] = null;
			__observeAutoSave.isAutoSaveMode = false;
			let saveTimeEmt = document.querySelector("#autoSaveTime");
			if (saveTimeEmt) {
				saveTimeEmt.textContent = "";
			}
			if (__autoSaveDataObj["eventCnChangeEvent"]) {
				__autoSaveDataObj["eventCnChangeEvent"].removeListener();
				__autoSaveDataObj["eventCnChangeEvent"] = null;
			}
			if (__autoSaveDataObj["eventCn2ChangeEvent"]) {
				__autoSaveDataObj["eventCn2ChangeEvent"].removeListener();
				__autoSaveDataObj["eventCn2ChangeEvent"] = null;
			}
			// 이벤트 분류 초기화
			document.querySelectorAll(".btn-evnt").forEach((v, i) => {
				v.classList.remove("active");
			});
			$("#evntSe").val("");
			$("#evntSe_old").val("");

			// 근무자 초기화
			document.getElementsByName("wrkr")[0].value = "";

			// 추가 설정(공정, 설비, 설비 상세) 초기화
			$("#addSettingTxt").text("");
			// 태그 분류 설정 초기화
			document.querySelectorAll(".btn-tag").forEach((v, i) => {
				v.classList.remove("click");
			});
			$("input[name='procs_id']").val("");
			$("input[name='fclt_id']").val("");
			$("input[name='fclt_dtl_id']").val("");

			$("#BTNGRP_FD button").remove();// 설비 상세 버튼 지우기

			// 시작/종료 일시 초기화
			let now = new Date();
			let start = new Date(now.getFullYear(), now.getMonth(), now.getDate(), now.getHours(), Math.ceil(now.getMinutes() / 10) * 10);
			let end = new Date(now.getFullYear(), now.getMonth(), now.getDate(), now.getHours(), Math.ceil(now.getMinutes() / 10) * 10);

			setDateTimeNoLimit($("#strtDate"), $("#strtTime"), start, "m");
			setDateTimeNoLimit($("#endDate"), $("#endTime"), end, "m");
			document.querySelector("#strtDate").disabled = true;
			document.querySelector("#strtTime").disabled = true;
			document.querySelector("#endDate").disabled = true;
			document.querySelector("#endTime").disabled = true;

			$("input[name='bgng_dt']").val();
			$("input[name='bgng_dt_old']").val("");
			$("input[name='end_dt']").val("");

			// 이벤트 내용 초기화
			document.querySelector("#titleEvntCn").innerText = "이벤트 내용";

			// 이벤트 설명 초기화
			CKEDITOR.instances.evnt_cn.setData("");
			CKEDITOR.instances.evnt_cn2.setData("");

			// 첨부파일 초기화
			// 파일 첨부 관련 필드 초기화
			document.getElementById("fileName1").value = "";
			document.getElementById("fileName2").value = "";
			document.getElementById("fileInput1").value = "";
			document.getElementById("fileInput2").value = "";

			$("#btnSlideSetting").removeClass("slide-up");
			$("#btnSlideSetting").addClass("slide-down");
			$("#settingBox").hide();

			let ckeEvntCnEmt = document.querySelector("#cke_evnt_cn");
			let ckeEvntCn2Emt = document.querySelector("#cke_evnt_cn2");

			if (ckeEvntCnEmt && CKEDITOR.instances.evnt_cn) {
				__autoSaveDataObj["eventCnChangeEvent"] = CKEDITOR.instances.evnt_cn.on("change", () => {
					if (__dataObj["evntCn"] != CKEDITOR.instances.evnt_cn.getData()) {
						__observeAutoSave.isAutoSaveMode = true;
					} else {
						__observeAutoSave.isAutoSaveMode = false;
					}
				});
			}
			if (ckeEvntCn2Emt && CKEDITOR.instances.evnt_cn2) {
				__autoSaveDataObj["eventCn2ChangeEvent"] = CKEDITOR.instances.evnt_cn2.on("change", () => {
					if (__dataObj["evntCn2"] != CKEDITOR.instances.evnt_cn2.getData()) {
						__observeAutoSave.isAutoSaveMode = true;
					} else {
						__observeAutoSave.isAutoSaveMode = false;
					}
				});
			}

			if (type == "add" || type == "init") {
				__dataObj["evntCn"] = "";
				__dataObj["evntCn2"] = "";
				if (ckeEvntCnEmt) {
					if (CKEDITOR.instances.evnt_cn && CKEDITOR.instances.evnt_cn.instanceReady) {
						$("#btnSlideEvntCn").removeClass("slide-down");
						$("#btnSlideEvntCn").addClass("slide-up");
						$("#evntCnBox").show();
					}
				}
				if (ckeEvntCn2Emt) {
					if (CKEDITOR.instances.evnt_cn2 && CKEDITOR.instances.evnt_cn2.instanceReady) {
						$("#btnSlideEvntCn2").removeClass("slide-up");
						$("#btnSlideEvntCn2").addClass("slide-down");
						$("#evntCn2Box").hide();
					} else {
						if (!CKEDITOR.instances.evnt_cn2.hasListeners("instanceReady")) {
							CKEDITOR.instances.evnt_cn2.on("instanceReady", function(evt) {
								$("#btnSlideEvntCn2").removeClass("slide-up");
								$("#btnSlideEvntCn2").addClass("slide-down");
								$("#evntCn2Box").hide();
							});
						}
					}
				}
				if (type == "add" && (localStorage.tempEvntCn || localStorage.tempEvntCn2)) {
					if (confirm("임시저장된 내용이 있습니다. 불러오시겠습니까?")) {
						setTimeout(function() {
							CKEDITOR.instances.evnt_cn.updateElement();
							CKEDITOR.instances.evnt_cn.setData(localStorage.tempEvntCn);
							CKEDITOR.instances.evnt_cn2.updateElement();
							CKEDITOR.instances.evnt_cn2.setData(localStorage.tempEvntCn2);
							delete localStorage.tempEvntCn;
							delete localStorage.tempEvntCn2;
						}, 1);
					} else {
						delete localStorage.tempEvntCn;
						delete localStorage.tempEvntCn2;
					}
				}
			}
		};

		// 이벤트 신규 추가
		function onSaveEvntInfo(isPopup) {
			CKEDITOR.instances.evnt_cn.updateElement();
			CKEDITOR.instances.evnt_cn2.updateElement();
			// <p> 태그가 있을 때만 iframe 생성 및 form 제출 진행
			let ifrm = document.createElement("iframe");
			ifrm.id = "blankifr";
			ifrm.name = "blankifr";
			ifrm.style.display = "none";
			document.getElementsByTagName("body")[0].appendChild(ifrm);

			// iframe 로딩 완료 후 동작 처리
			if (isPopup) {
				document.getElementById("blankifr").onload = function(data) {
					try {
						if (data) {
							alert("이벤트 추가가 완료되었습니다.");
							let evnt_id = data.srcElement.contentDocument.body.textContent;
							ifrm.remove();
							search(evnt_id);
						}
					} catch (e) {
						console.error(e);
					} finally {
						ifrm.remove();
					}
				};
			}

			// form 설정 및 제출
			let form = document.getElementById("atchForm");
			form.action = "onSaveEvntInfo";
			form.target = "blankifr";
			form.evnt_se.value = form.evnt_se.value.replace("evnt", "");

			let start = new Date($("#strtDate").val() + " " + $("#strtTime").val() + ":00");
			start.setMinutes(Math.ceil(start.getMinutes() / 10) * 10);
			let strtDateStr = start.getFullYear() + String(start.getMonth() + 1).padStart(2, "0") + String(start.getDate()).padStart(2, "0");
			let strtTimeStr = String(start.getHours()).padStart(2, "0") + String(start.getMinutes()).padStart(2, "0");
			form.bgng_dt.value = strtDateStr + strtTimeStr;
			if (form.bgng_dt.value.length == 12) {
				form.bgng_dt.value += "00";
			}
			let end = new Date($("#endDate").val() + " " + $("#endTime").val() + ":00");
			end.setMinutes(Math.ceil(end.getMinutes() / 10) * 10);
			let endDateStr = end.getFullYear() + String(end.getMonth() + 1).padStart(2, "0") + String(end.getDate()).padStart(2, "0");
			let endTimeStr = String(end.getHours()).padStart(2, "0") + String(end.getMinutes()).padStart(2, "0");
			form.end_dt.value = endDateStr + endTimeStr;
			if (form.end_dt.value.length == 12) {
				form.end_dt.value += "00";
			}

			let files = document.querySelectorAll("#fileContainer input[type='file']");
			let fileCnt = 0;
			for (let i = 0; i < files.length; i++) {
				fileCnt += files[i].files.length;
			}
			form.fileCnt.value = fileCnt;

			form.submit();
		};

		// 이벤트 관리(수정)
		function onUpdateEvntInfo(isPopup) {
			// 이벤트 분류와 시작 일시가 동일하면 기존 내용 수정
			// 둘중 하나라도 다르면 이벤트 추가로 판정
			let evnt_se = $("input[name='evnt_se']").val();
			let evnt_se_old = $("input[name='evnt_se_old']").val();

			let start = new Date($("#strtDate").val() + " " + $("#strtTime").val() + ":00");
			start.setMinutes(Math.ceil(start.getMinutes() / 10) * 10);
			let strtDateStr = start.getFullYear() + "-" + String(start.getMonth() + 1).padStart(2, "0") + "-" + String(start.getDate()).padStart(2, "0");
			let strtTimeStr = String(start.getHours()).padStart(2, "0") + ":" + String(start.getMinutes()).padStart(2, "0");
			let bgng_dt = strtDateStr + " " + strtTimeStr;
			let bgng_dt_old = $("input[name='bgng_dt_old']").val();

			if ((evnt_se == evnt_se_old) && (bgng_dt == bgng_dt_old)) {
				let ifrm = document.createElement("iframe");
				ifrm.id = "blankifr";
				ifrm.name = "blankifr";
				ifrm.style.display = "none";
				document.getElementsByTagName("body")[0].appendChild(ifrm);

				if (isPopup) {
					document.getElementById("blankifr").onload = function(data) {
						try {
							alert("이벤트 수정이 완료되었습니다.");
							let evnt_id = JSON.parse(data.srcElement.contentDocument.body.textContent).evnt_id;
							ifrm.remove();
							search(evnt_id);
						} catch(e) {
							console.error(e);
						} finally {
							ifrm.remove();
						}
					};
				}

				let form = document.getElementById("atchForm");
				form.action = "onUpdateEvntInfo";
				form.target = "blankifr";
				form.evnt_se.value = form.evnt_se.value.replace("evnt", "");
				// 날짜 및 시간 설정
				strtDateStr = strtDateStr.replaceAll("-", "");
				strtTimeStr = strtTimeStr.replaceAll(":", "");
				form.bgng_dt.value = strtDateStr + strtTimeStr;
				if (form.bgng_dt.value.length == 12) {
					form.bgng_dt.value += "00";
				}
				let end = new Date($("#endDate").val() + " " + $("#endTime").val() + ":00");
				end.setMinutes(Math.ceil(end.getMinutes() / 10) * 10);
				let endDateStr = end.getFullYear() + String(end.getMonth() + 1).padStart(2, "0") + String(end.getDate()).padStart(2, "0");
				let endTimeStr = String(end.getHours()).padStart(2, "0") + String(end.getMinutes()).padStart(2, "0");
				form.end_dt.value = endDateStr + endTimeStr;
				if (form.end_dt.value.length == 12) {
					form.end_dt.value += "00";
				}
				// 파일 카운트 설정
				let files = document.querySelectorAll("#fileContainer input[type='file']");
				let fileCnt = 0;
				for (let i = 0; i < files.length; i++) {
					fileCnt += files[i].files.length;
				}

				form.fileCnt.value = fileCnt;
				form.submit();
			} else {
				onSaveEvntInfo(isPopup);
			}
		};

		// 이벤트 삭제
		function onDeleteEvntInfo() {
			if (confirm("정말 삭제하시겠습니까?")) {
				let ifrm = document.createElement("iframe");
				ifrm.id = "blankifr";
				ifrm.name = "blankifr";
				ifrm.style.display = "none";
				document.getElementsByTagName("body")[0].appendChild(ifrm);
				// 아이프레임 onload 이벤트 핸들러
				ifrm.onload = function() {
					try {
						alert("이벤트가 삭제되었습니다.");
						ifrm.remove();
						search();
					} catch (e) {
						console.error(e);
					} finally {
						ifrm.remove();
					}
				};

				let form = document.getElementById("atchForm");
				form.action = "onDeleteEvntInfo";
				form.target = "blankifr";
				form.submit(); // 폼 제출
			}
		};

		// window 이벤트 ----------------------------------------------------------------------------------
		async function onChngFcltSel(id, fclt_id) {
			$("#" + id + " option").remove();
			if (!!fclt_id) {
				$("#" + id).append("<option value='*'>전체</option>");
				if (fclt_id != "*") {
					let data = await getFcltDeatilInfoList(fclt_id);
					$("#"+id).append("<option value='*'>전체</option>");
					for (let obj of data) {
						$("#"+id).append("<option value='" + obj.CD_ID + "'>" + obj.CD_NM + "</option>");
					}
					if(data.length == 0) {
						$("#"+id).append("<option value='*'>-</option>");
					}
				}
			}
		};

		async function onChangeFclt(fclt_id, fclt_dtl_id) {
			// 분류 설정에서 설비에 따라 설비 상세 변경하는
			$("#BTNGRP_FD button").remove();
			$("input[name='fclt_dtl_id']").val("");
			if (!!fclt_id) {
				let detailList = await getFcltDeatilInfoList(fclt_id);
				for (let obj of detailList) {
					$("#BTNGRP_FD").append("<button id='" + obj.CD_ID + "' class='btn-tag' title='" + obj.CD_NM + "'>" + obj.CD_NM + "</button>");
				}
				document.getElementById("BTNGRP_FD").querySelectorAll(".btn-tag").forEach(button => {
					button.addEventListener("click", function() {
						// click class 삭제
						if (this.classList.contains("click")) {
							this.classList.remove("click");
							$("input[name='fclt_dtl_id']").val("");
							AddSettingText();
							return;
						}
						this.parentElement.childNodes.forEach(btn => btn.classList.remove("click"));
						this.classList.add("click");
						$("input[name='fclt_dtl_id']").val(this.id);
						AddSettingText();
						toggleBox(btnSlideSetting, "settingBox", false);
						CKEDITOR.instances.evnt_cn.focus();
					});
				});

				if (!!fclt_dtl_id) {
					$("#BTNGRP_FD #" + fclt_dtl_id).trigger("click");
				}
			}
		};

		function showAddEvntForm(type) {
			// 추가 버튼 클릭 시 오른쪽 이벤트 등록 폼 보여주기
			initAddEvntForm(type);

			if (type == "add" || type == "init") {
				$("#titleEvntModify").hide();
				$("#titleEvntModify1").hide();
				$("#titleEvntAdd").show();
				$("#titleEvntAdd1").show();
			} else {
				$("#titleEvntAdd").hide();
				$("#titleEvntAdd1").hide();
				$("#titleEvntModify").show();
				$("#titleEvntModify1").show();
			}

			$(".right-box").css("display", "flex");
		};

		// 대상 Element 선택
		const resizer = document.getElementsByClassName("snb_split_area")[0];
		const leftSide = resizer.previousElementSibling;
		const rightSide = resizer.nextElementSibling;

		// 마우스의 위치값 저장을 위해 선언
		let x = 0;
		let y = 0;

		// 크기 조절시 왼쪽 Element를 기준으로 삼기 위해 선언
		let leftWidth = 0;

		// resizer에 마우스 이벤트가 발생하면 실행하는 Handler
		const mouseDownHandler = function (e) {
			// 마우스 위치값을 가져와 x, y에 할당
			x = e.clientX;
			y = e.clientY;
			// left Element에 Viewport 상 width 값을 가져와 넣음
			leftWidth = leftSide.getBoundingClientRect().width;

			// 마우스 이동과 해제 이벤트를 등록
			document.addEventListener("mousemove", mouseMoveHandler);
			document.addEventListener("mouseup", mouseUpHandler);
		};

		const mouseMoveHandler = function (e) {
			// 마우스가 움직이면 기존 초기 마우스 위치에서 현재 위치값과의 차이를 계산
			const dx = e.clientX - x;
			const dy = e.clientY - y;

			// 크기 조절 중 마우스 커서를 변경함
			// class="resizer"에 적용하면 위치가 변경되면서 커서가 해제되기 때문에 body에 적용
			document.body.style.cursor = "col-resize";

			// 이동 중 양쪽 영역(왼쪽, 오른쪽)에서 마우스 이벤트와 텍스트 선택을 방지하기 위해 추가
			leftSide.style.userSelect = "none";
			leftSide.style.pointerEvents = "none";

			rightSide.style.userSelect = "none";
			rightSide.style.pointerEvents = "none";

			// 초기 width 값과 마우스 드래그 거리를 더한 뒤 상위요소(container)의 너비를 이용해 퍼센티지를 구함
			// 계산된 퍼센티지는 새롭게 left의 width로 적용
			let newLeftWidth = ((leftWidth + dx) * 100) / resizer.parentNode.getBoundingClientRect().width;

			if (newLeftWidth < 10) {
				newLeftWidth = 10;
			}
			let newRightWidth = 100 - newLeftWidth;

			if (newRightWidth < 30) {
				newRightWidth = 30;
				newLeftWidth = 70;
			}

			leftSide.style.width = `\${newLeftWidth}%`;
			rightSide.style.width = `\${newRightWidth}%`;

			$("#eventList").jsGrid("refresh");
		};

		const mouseUpHandler = function () {
			const leftWidth = (leftSide.style.width).replace("%", "");
			// 모든 커서 관련 사항은 마우스 이동이 끝나면 제거됨
			resizer.style.removeProperty("cursor");
			document.body.style.removeProperty("cursor");

			leftSide.style.removeProperty("user-select");
			leftSide.style.removeProperty("pointer-events");

			rightSide.style.removeProperty("user-select");
			rightSide.style.removeProperty("pointer-events");

			// 등록한 마우스 이벤트를 제거
			document.removeEventListener("mousemove", mouseMoveHandler);
			document.removeEventListener("mouseup", mouseUpHandler);
		};

		// 마우스 down 이벤트를 등록
		resizer.addEventListener("mousedown", mouseDownHandler);
		// window 이벤트 end ----------------------------------------------------------------------------------

		// 첨부파일 관리 ----------------------------------------------------------------------------------

		// 파일 선택 시
		function handleFileSelect(event) {
			const file = event.files[0];

			if (file.type == "") {
				alert("알수 없는 확장자 입니다. 저장 가능한 파일을 첨부해주세요.");
				return;
			}
			const fileId = event.dataset.fileId;
			const fileNameInput = document.getElementById("fileName" + fileId);

			if (file) {
				fileNameInput.value = file.name;
			} else {
				fileNameInput.value = "";
			}
		};

		// 미리보기 버튼 클릭 시
		function handleFilePreview(event) {
			const fileId = event.dataset.fileId;
			const fileInput = document.getElementById("fileInput" + fileId); // fileId와 결합
			const file = fileInput.files[0];

			if (file) {
				const reader = new FileReader();
				reader.onload = function(e) {
					const fileType = file.type.split("/")[0];
					const src = e.target.result;
					let fileUrl = "";

					if (fileType === "image") {
						// Blob URL 만들기
						fileUrl = URL.createObjectURL(new Blob([src], { type: file.type }));
						const previewWindow = window.open("", "File Preview", "width=600,height=400");
						// 파일 미리보기 팝업 열기
						previewWindow.document.open();
						previewWindow.document.write('<html><head><title>미리보기</title></head><body><img src="' + fileUrl + '" alt="Image Preview" style="max-width: 100%; height: auto;"></body></html>');
						previewWindow.document.close();

						previewWindow.onload = function() {
							const img = previewWindow.document.querySelector("img");
							if (img) {
								// 창 크기 조절
								previewWindow.resizeTo(img.width + 80, img.height + 120);
								// 창을 화면 중앙에 배치
								const left = (window.screen.availWidth - previewWindow.outerWidth) / 2;
								const top = (window.screen.availHeight - previewWindow.outerHeight) / 2;
								previewWindow.moveTo(left, top);
							}
						};
					} else if (fileType === "audio") {
						// Blob URL 만들기
						fileUrl = URL.createObjectURL(new Blob([src], { type: file.type }));
						// 파일 미리보기 팝업 열기
						const previewWindow = window.open("", "File Preview", "width=600,height=400");
						previewWindow.document.open();
						previewWindow.document.write('<html><head><title>미리듣기</title></head><body><audio controls><source src="' + fileUrl + '" type="' + file.type + '">Your browser does not support the audio element.</audio></body></html>');
						previewWindow.document.close();

						// 스크립트 동적으로 추가하여 창 크기 조정 및 중앙 배치
						previewWindow.onload = function() {
							const audio = previewWindow.document.querySelector("audio");
							if (audio) {
								// 오디오 크기에 맞게 창 크기 조절
								previewWindow.resizeTo(330, 150); // 오디오의 기본 크기에 맞춰 설정
								// 창을 화면 중앙에 배치
								const left = (window.screen.availWidth - previewWindow.outerWidth) / 2;
								const top = (window.screen.availHeight - previewWindow.outerHeight) / 2;
								previewWindow.moveTo(left, top);
							}
						};
					}
				};
				reader.readAsArrayBuffer(file);
			} else {
				alert("먼저 파일을 첨부해 주세요.");
			}
		};

		$("#previewDlg").dialog({
			autoOpen: false,
			resizable: true,
			closeOnEscape: false,
			width: "max(500px, 36.2vw)",
			open: function(args) {
				setTimeout(function() {
					$("#previewDlg").dialog("option", "position", {my: "center", at:"center", of: window});
				}, 1);
			},
			buttons: {
				"취소": function() {
					$(this).dialog("close");
				},
				"다운로드": function() {
					$(this).dialog("close");
				},
			}
		});

		function openPreviewDlg(savedFileInfo) {
			let byte_img = savedFileInfo.byte_img;
			let file_type = savedFileInfo.file_type;
			let orgnl_file_nm = savedFileInfo.orgnl_file_nm;

			// 버튼 스타일 및 레이블 변경
			$(".ui-dialog-buttonset button:first-child").addClass("btnPopCancel");

			// 기타 설정
			$(".ui-widget-header").addClass("title-style");
			$(".ui-dialog-titlebar-close").remove();

			$("#previewDlg img").show();
			$("#previewDlg input[type='file']").hide();

			let blob = b64toBlob(byte_img, file_type);
			let blobUrl = URL.createObjectURL(blob);
			const file = new File([blob], orgnl_file_nm, {type: file_type});
			const fileList = new DataTransfer();
			fileList.items.add(file);
			document.querySelector("input[name=previewFile]").files = fileList.files;

			if(file_type.includes("image")) {
				$("#previewDlg #audio").hide();
				$("#previewDlg #img").show();
				$("#img").attr("src", blobUrl);
				// $("#img").css("height", "auto");
			} else if (file_type.includes("audio")) {
				$("#previewDlg #audio").show();
				$("#previewDlg #img").hide();

				let audio_file = document.querySelector("input[name=previewFile]").files[0];
				const reader = new FileReader();
				reader.onload = function(e) {
					const src = e.target.result;
					// Blob URL 만들기
					let fileUrl = URL.createObjectURL(new Blob([src], { type: audio_file.type }));
					$("#audio").attr("src", fileUrl);
				};
				reader.readAsArrayBuffer(audio_file);
			}
			// 다이얼로그 열기 및 타이틀 설정
			$("#previewDlg").dialog("option", "title", "미리보기").dialog("open");
		};

		const b64toBlob = (b64Data, contentType="", sliceSize=512) => {
			const byteCharacters = atob(b64Data);
			const byteArrays = [];

			for (let offset = 0; offset < byteCharacters.length; offset += sliceSize) {
				const slice = byteCharacters.slice(offset, offset + sliceSize);
				const byteNumbers = new Array(slice.length);
				for (let i = 0; i < slice.length; i++) {
					byteNumbers[i] = slice.charCodeAt(i);
				}

				const byteArray = new Uint8Array(byteNumbers);
					byteArrays.push(byteArray);
			}

			const blob = new Blob(byteArrays, {type: contentType});
			return blob;
		};
		// 첨부파일 관리 end -----------------------------------------------------------------------------

		function toggleBox(emt, targetId, isShow) {
			if (isShow == null || isShow == undefined) {
				if (emt.classList.value == "slide-down") {
					isShow = true;
				} else {
					isShow = false;
				}
			}
			if (isShow) {
				emt.classList.remove("slide-down");
				emt.classList.add("slide-up");
				$(`#\${targetId}`).show();
				if (targetId == "evntCnBox") {
					CKEDITOR.instances.evnt_cn.updateElement();
					//CKEDITOR.instances.evnt_cn.insertHtml(__dataObj["evntCn"]);
					if (!CKEDITOR.instances.evnt_cn.getData()) {
						CKEDITOR.instances.evnt_cn.setData(__dataObj["evntCn"]);
						__dataObj["evntCn"] = CKEDITOR.instances.evnt_cn.getData();
					}
				}
				if (targetId == "evntCn2Box") {
					CKEDITOR.instances.evnt_cn2.updateElement();
					//CKEDITOR.instances.evnt_cn2.insertHtml(__dataObj["evntCn2"]);
					if (!CKEDITOR.instances.evnt_cn2.getData()) {
						CKEDITOR.instances.evnt_cn2.setData(__dataObj["evntCn2"]);
						__dataObj["evntCn2"] = CKEDITOR.instances.evnt_cn2.getData();
					}
				}
			} else {
				emt.classList.remove("slide-up");
				emt.classList.add("slide-down");
				$(`#\${targetId}`).hide();
			}
		};

		function timeOnBlurEvent() {
			let blurEvt = function(ev) {
				let dateEmtId = this.id.replaceAll("Time", "Date");
				let dateEmt = document.querySelector(`#\${dateEmtId}`);

				let date = new Date(dateEmt.value + " " + this.value + ":00");
				date.setMinutes(Math.ceil(date.getMinutes() / 10) * 10);
				let dateStr = date.getFullYear() + "-" + String(date.getMonth() + 1).padStart(2, "0") + "-" + String(date.getDate()).padStart(2, "0");
				let timeStr = String(date.getHours()).padStart(2, "0") + ":" + String(date.getMinutes()).padStart(2, "0");

				dateEmt.value = dateStr;
				this.value = timeStr;
			};
			document.querySelector("#strtTime").addEventListener("blur", blurEvt);
			document.querySelector("#endTime").addEventListener("blur", blurEvt);
		};
		/*
		// 그리드 글자 넘김 방지
		function applyEllipsis(grid, value) {
			document.querySelectorAll(`#\${grid.id} .jsgrid-header-cell`).forEach(function(th) {
				let headerWidth = th.style.width;
				document.querySelectorAll(`#\${grid.id} .jsgrid-cell:nth-child(\${th.cellIndex + 1})`).forEach(function(td) {
					td.style.width = headerWidth;
				});
			});
			return $("<div>").css({
				"white-space": "nowrap",
				"overflow": "hidden",
				"text-overflow": "ellipsis"
			}).attr("title", value) // 마우스 오버 시 전체 텍스트 표시
			.text(value); // 텍스트 내용
		};
		*/

		function excelDownload() {
			window.location.href = "ai0101/excel?bgng_dt=" + ($("#date1").val()).replaceAll("-", "");
		};
	</script>
</body>
</html>