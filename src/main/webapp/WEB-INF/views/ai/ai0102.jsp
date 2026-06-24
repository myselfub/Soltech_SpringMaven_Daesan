<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	language="java"%>
<%@ page session="true"%>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트 정보 검색</title>
<script src="resources/js/sheetJS/xlsx.full.min.js"></script>
<script src="resources/js/sheetJS/xlsx.bundle.js"></script>
<script src="resources/js/FileSaver.min.js"></script>
<script src="resources/js/moment.js"></script>
</head>
<body>
	<div id="main" class="ai-system main-screen">
		<p class="main-title">이벤트 정보 검색</p>
		<div id="searchAI" class="main-search-group">
			<div class="flex-col-10">
				<div class="flex-row-10">
					<div class="com-search-unit">
						<div class="flex-row-10">
							<p class="title-w80">이벤트 분류</p>
							<select id="evntSel"><option>-</option></select>
						</div>
					</div>
					<div class="com-search-unit">
						<div class="flex-row-10">
							<p class="title-wauto">공정 분류</p>
							<select id="procsSel"><option>-</option></select>
						</div>
					</div>
					<div class="com-search-unit" style="margin: 0">
						<p class="title-wauto">조회 일시</p>
						<input id="date1" type="date" required pattern="\d{4}\d{2}\d{2}"
							max="9999-12-31" /> <input type="time" id="time1">~ <input
							id="date2" type="date" required pattern="\d{4}\d{2}\d{2}"
							max="9999-12-31" /> <input type="time" id="time2">
						<button id="btnSearch" class="find" onClick="search()">
							<img />
						</button>
					</div>
				</div>
				<div class="com-search-unit" id="searchGrpFclt">
					<div class="flex-row-10">
						<p class="title-w80">설비 분류</p>
						<div id="fcltCkBox" class="flex-row-10"></div>
					</div>
				</div>
				<div class="com-search-unit" id="searchGrpFcltDtl">
					<div class="flex-row-10">
						<p class="title-w80">상세 분류</p>
						<div id="fcltDCkBox" class="flex-col-10">
							<div style="color: #002C99;">설비 분류를 선택하면 상세 분류가 표시됩니다.</div>
						</div>
					</div>
				</div>
				<div class="com-search-unit"></div>
			</div>
			<div class="com-search-unit"
				style="flex-direction: column; height: 100%; justify-content: flex-end;">
				<div style="display: flex; justify-content: flex-end;"
					onclick="tggleSearchGroup(this);">
					<div class="slide-up"></div>
				</div>
			</div>
		</div>
		<div id="dataBox" class="main-data-group main-contents-grid2"
			style="width: 100%; height: 76%;">
			<div class="flex-col-10"
				style="flex-basis: 61%; height: 100%; overflow-x: auto;">
				<div class="grd-search-grp flex-row-10">
					<p class="title-bold-w80">이벤트 목록</p>
					<input type="text" id="searchEventTag" class="search-ai-input"
						placeholder="내용 검색" onkeydown="onEnterSearch(event)" />
					<button id="btnSearch" class="find" onClick="searchGrid1()">
						<img />
					</button>
				</div>
				<div id="eventList" class="event-list" style="height: 100%;"></div>
				<div class="flex-row-10" style="height: auto;">
					<p class="title-bold-w80">이벤트 상세</p>
					<button class="searchIcn evnt-btn" onclick="toggleEvntDtlBox();"
						id="btnEvntDtlBox">보기</button>
				</div>
				<div id="evntDetailBox" class="flex-row-10"
					style="height: auto; border: 1px solid #DADAE2; padding: 0.65rem;">
					<div class="flex-col-10">
						<div class="flex-row-10" style="flex: 1 1 0;">
							<div class="flex-row-10" style="width: 100%;">
								<p class="ai-sub-title">이벤트 분류</p>
								<input type="text" class="justText" id="evntDtl_evntSe"
									style="width: 100%;" readonly>
							</div>
							<div class="flex-row-10" style="width: 100%;">
								<p class="ai-sub-title">근무자</p>
								<input type="text" class="justText" id="evntDtl_wrkr"
									style="width: 100%;" readonly>
							</div>
						</div>
						<div class="flex-row-10">
							<p class="ai-sub-title">시작 일시</p>
							<input type="text" class="justText" style="width: auto;"
								id="evntDtl_bgngDt" readonly>
							<p class="ai-sub-title">종료 일시</p>
							<input type="text" class="justText" style="width: auto;"
								id="evntDtl_endDt" readonly>
						</div>
						<div class="flex-row-10">
							<div class="flex-row-10">
								<p class="ai-sub-title">공정 분류</p>
								<input type="text" class="justText" style="width: auto;"
									id="evntDtl_procs" readonly>
							</div>
							<div class="flex-row-10">
								<p class="ai-sub-title">설비 분류</p>
								<input type="text" class="justText" style="width: auto;"
									id="evntDtl_fclt" readonly>
							</div>
						</div>
						<div class="flex-row-10">
							<p class="ai-sub-title">상세 분류</p>
							<input type="text" class="justText" style="width: auto;"
								id="evntDtl_fcltDtl" readonly>
						</div>
					</div>
					<div class="flex-col-10" style="width: 100%; height: 100%;">
						<div class="flex-row-10">
							<p id="titleEvntCn" class="ai-sub-title">이벤트 내용</p>
							<div class="justText" id="evntDtl_evntCn" style="height: 4.2rem;"></div>
							<!-- <textarea class="justText" style="width: auto; height: 100%;" id="evntDtl_evntCn" readonly></textarea> -->
						</div>
						<div class="flex-row-10">
							<p class="ai-sub-title">조치 내용</p>
							<div class="justText" id="evntDtl_evntCn2" style="height: 4.2rem;"></div>
							<!-- <textarea class="justText" style="width: auto; height: 100%;" id="evntDtl_evntCn" readonly></textarea> -->
						</div>
					</div>
				</div>
			</div>
			<div class="flex-col-10" style="flex-basis: 39%; overflow-x: auto;">
				<div class="grd-search-grp"
					style="display: flex; justify-content: space-between; width: 100%;">
					<div class="flex-row-10">
						<p class="title-bold-w60">태그 목록</p>
						<input type="text" id="searchProcTag" class="search-ai-input"
							placeholder="태그명 검색" onkeydown="onEnterSearch(event)" /> <input
							type="text" id="searchProcTagDesc" class="search-ai-input"
							placeholder="태그 설명 검색" onkeydown="onEnterSearch(event)" />
						<button id="btnSearch" class="find" onClick="searchGrid2()">
							<img />
						</button>
					</div>
					<div class="flex-row-10" style="margin-right: 0.65rem;">
						<img class="searchIcn trnd" onclick="openPopupTrend();"
							alt="트렌드 보기" title="트렌드 보기"> <img class="searchIcn grid"
							onclick="popTagGrid();" alt="그리드 보기" title="그리드 보기">
					</div>
				</div>
				<div id="procTagList" class="proc-tag-List"></div>
			</div>
		</div>
		<div id="procTagDlg">
			<div id="popTagList"></div>
		</div>
	</div>
	<script>
		const __dataObj = {
			"startX": 0,
			"startWidth": 0,
			"changeWidth": 0,
			"grdEventData": null,
			"eventListMinWidth": 50,
			"eventListMaxWidth": 500,
			"procTagListMinWidth": 50,
			"procTagListMaxWidth": 400,
			"popTagListMinWidth": 50,
			"popTagListMaxWidth": 250
		};
		const s_PageSize = 1000;
		// 처음 페이지 로드시
		window.onload = function() {
			init();
		};

		async function init() {
			// 조회 기간 설정
			let start = new Date(), end = new Date();
			start.setHours(0);

			setDateTime($("#date1"), $("#time1"), start);
			setDateTime($("#date2"), $("#time2"), end);

			// 이벤트 분류 조회
			let evnt_data = await getEvntInfoList();
			$("#evntSel option").remove();

			$("#evntSel").append("<option value='*'>전체</option>");
			for (let obj of evnt_data) {
				$("#evntSel").append("<option value='" + obj.CD_ID + "'>" + obj.CD_NM + "</option>");
			}

			// 공정 목록 조회
			let procsList = await getProcInfoList(undefined, "data", "Y");
			$("#procsSel option").remove();

			$("#procsSel").append("<option value='*'>전체</option>");
			for (let obj of procsList) {
				$("#procsSel").append("<option value='" + obj.PROCS_ID + "'>" + obj.PROCS_NM + "</option>");
				//$("#procCkBox").append("<label><input type='checkbox' name='proc_ck' value='" + obj.PROCS_ID + "' checked>" + obj.PROCS_NM + "</label>");
			}

			let fcltList = await getFcltInfoList();
			$("#fcltCkBox label").remove();
			$("#fcltCkBox").append("<label><input type='checkbox' id='checkFAll' name='fclt_ck' value='*' >전체</label>");
			// 전체 체크박스 클릭 이벤트 핸들러
			$("#fcltCkBox").on("change", "#checkFAll", function() {
				// "전체" 체크박스의 체크 상태를 가져옴
				const isChecked = $(this).is(":checked");
				// 모든 체크박스의 체크 상태를 "전체" 체크박스의 상태에 맞춤
				$("input[name='fclt_ck']").prop("checked", isChecked);
				getFcltDList();
			});

			for (let obj of fcltList) {
				$("#fcltCkBox").append("<label><input type='checkbox' name='fclt_ck' value='" + obj.CD_ID + "' onchange='getFcltDList();'>" + obj.CD_NM + "</label>");
			}
			toggleEvntDtlBox();
		};

		function getFcltDList() {
			let fclt_list = new Array();
			$("input[name='fclt_ck']").each(function(index, item) {
				if (item.value != "*") {
					if (item.checked) {
						fclt_list.push(item.value);
					}
				}
			});

			if (fclt_list.length > 0) {
				let checkedList = new Object();
				$(".fdgroup input[type='checkbox']").each(function(idx, item) {
					if (item.checked) {
						checkedList[item.name + "_" + item.value] = item;
					}
				});

				$.ajax ({
					type: "POST",
					contentType: "application/json; charset=utf-8",
					cache: false,
					url: "getFcltDList",
					dataType: "json",
					data: JSON.stringify({fcltList: fclt_list}),
					success: function(res) {
						let obj = new Object();
						for (let data of res) {
							if (!!!obj[data.CD_SE]) {
								obj[data.CD_SE] = {
									desc: data.CD_DESC,
									cdList: new Array()
								};
							}
							obj[data.CD_SE].cdList.push(data);
						}
						$("#fcltDCkBox div").remove();

						for (let cd in obj) {
							let cdObj = obj[cd];
							let allChecked = (!!checkedList[cd+"_ck_all"]? "checked" : "");
							$("#fcltDCkBox").append(`<div id="\${cd}" class="fdgroup"><label class="fdgroup-title">\${cdObj.desc}</label>
									<label><input type="checkbox" id="\${cd}_ckAll" name="\${cd}_ck" value="all" onchange="onChgFcltDCkAll(this.id);" \${allChecked}>전체</label></div>`);

							for (let i in cdObj.cdList) {
								let fd = cdObj.cdList[i];
								if (!!checkedList[cd + "_ck_" + fd.CD_ID]) {
									$("#" + fd.CD_SE).append("<label><input type='checkbox' name='" + cd + "_ck' value='" + fd.CD_ID + "' checked>" + fd.CD_NM + "</label>");
								} else {
									$("#" + fd.CD_SE).append("<label><input type='checkbox' name='" + cd + "_ck' value='" + fd.CD_ID + "'>" + fd.CD_NM + "</label>");
								}
							}
						}

						let fdgroupCount = $("#fcltDCkBox div.fdgroup").length || 1;
						let diff = (fdgroupCount - 1) * 29;
						$("#dataBox").css("height", `calc(76% - \${diff}px)`);
						$("#eventList").jsGrid("refresh");
					}, error: function(e) {
						alert("설비 상세 목록 조회 실패");
					}
				});
			} else {
				$("#fcltDCkBox div").remove();
				$("#fcltDCkBox").append("<div style=\"color:#002C99;\">설비 분류를 선택하면 상세 분류가 표시됩니다.</div>");
				$("#dataBox").css("height", "76%");
				$("#eventList").jsGrid("refresh");
			}
		};

		function onChgFcltDCkAll(id) {
			let cd = id.split("_")[0];
			let checked = $("#" + id).is(":checked");
			$("input[name='" + cd + "_ck']").each(function(idx, item) {
				item.checked = checked;
			});
		};

		function search() {
			// 이벤트 목록 조회
			let evnt_se = $("#evntSel option:selected").val();
			// 공정
			let procs_id = $("#procsSel option:selected").val();
			// 설비
			let fclt_list = new Array();
			$("input[name='fclt_ck']").each(function(idx, item) {
				if (item.checked && item.value != "*") {
					fclt_list.push(item.value);
				}
			});

			// 설비 상세
			let fclt_dtl_list = new Array();
			$(".fdgroup").each(function(idx, item) {
				item.querySelectorAll("input[name='" + item.id + "_ck']").forEach(function(item, idx) {
					if (item.checked && item.value != "all") {
						fclt_dtl_list.push({fclt: (item.name).replace("_ck", ""), fclt_dtl: item.value});
					}
				});
			});

			let obj = {
				procs_id: procs_id,
				fclt_list: fclt_list,
				fclt_dtl_list: fclt_dtl_list,
				evnt_se: evnt_se,
				bgng_dt: ($("#date1").val()).replaceAll("-", "") + ($("#time1").val()).replaceAll(":", ""),
				end_dt: ($("#date2").val()).replaceAll("-", "") + ($("#time2").val()).replaceAll(":", "")
			};

			clearDtl();
			$("#eventList").jsGrid("loadData", obj);
		};

		// 이벤트 정보 jsGrid 설정
		$("#eventList").jsGrid({
			width: "99.8%",
			height: "99%",
			noDataContent: "No data.",
			editing: false,
			sorting: false,
			paging: true,
			pageSize: s_PageSize,
			fields: [
				{
					name: "evnt_se_nm",
					type: "text",
					width: 100,
					title: "이벤트 분류",
					align: "center",
					editing: false,
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
					name: "evnt_cn",
					type: "text",
					width: 195,
					title: "이벤트 내용",
					align: "left",
					editing: false,
					itemTemplate: function(value, row) {
						let firstLine = value.split("<br />")[0];
						let jsonstr = JSON.stringify({evnt_id: row.evnt_id, evnt_cn: row.evnt_cn});
						return `<div style="position: relative;">
							<div style="width: 100%; height: 100%; white-space: nowrap; text-overflow: ellipsis; overflow: hidden;" onmouseenter='showTooltipEvntCn(event, \${jsonstr});' onmouseleave='hideTooltipEvntCn( "\${row.evnt_id}");'>\${firstLine}</div>
							<div class="tooltip-text" id="tooltip_text_\${row.evnt_id}" style="z-index: 1;"></div>
							</div>`;
					}
				}, {
					name: "evnt_cn2",
					type: "text",
					width: 195,
					title: "조치 내용",
					align: "left",
					editing: false,
					itemTemplate: function(value, row) {
						if (value) {
							let firstLine = value.split("<br />")[0];
							let jsonStr = JSON.stringify({evnt_id: row.evnt_id, evnt_cn: row.evnt_cn2});
							return `<div style="position: relative;">
							<div style="width: 100%; height: 100%; white-space: nowrap; text-overflow: ellipsis; overflow: hidden;" onmouseenter='showTooltipEvntCn(\${jsonStr});' onmouseleave='hideTooltipEvntCn("\${row.evnt_id}");'>\${firstLine}</div>
							<div class="tooltip-text" id="tooltip_text_\${row.evnt_id}" style="z-index: 1;"></div>
							</div>`;
						} else {
							return `<div></div>`;
						}
					}
				}, {
					name: "procs_nm",
					type: "text",
					width: 110,
					title: "공정 분류",
					align: "center",
					itemTemplate: function(value, row) {
						return value ?? "-";
					}
				}, {
					name: "fclt_nm",
					type: "text",
					width: 110,
					title: "설비 분류",
					align: "center",
					itemTemplate: function(value, row) {
						return value ?? "-";
					}
				}, {
					name: "bgng_dt",
					type: "text",
					width: 145,
					title: "시작 일시",
					align: "center",
					editing: false
				}, {
					name: "end_dt",
					type: "text",
					width: 145,
					title: "종료 일시",
					align: "center",
					editing: false,
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
				},
			],
			rowDoubleClick: function(args) {
				// 선택된 row 표시
				$("#eventList .jsgrid-table tr").removeClass("jsgrid-highlight-row");
				$(args.event.currentTarget).addClass("jsgrid-highlight-row");
			},
			rowClick: function(args) {
				// 상세내용 하단에 표출
				$("#evntDtl_evntSe").val(args.item.evnt_se_nm);
				$("#evntDtl_wrkr").val(args.item.wrkr);
				$("#evntDtl_bgngDt").val(args.item.bgng_dt);
				$("#evntDtl_endDt").val(args.item.end_dt);
				$("#evntDtl_procs").val(args.item.procs_nm);
				$("#evntDtl_fclt").val(args.item.fclt_nm);
				$("#evntDtl_fcltDtl").val(args.item.fclt_dtl_nm);
				//let envt_cn = (args.item.evnt_cn).replace(/<[^>]*>?/g, "");
				$("#evntDtl_evntCn").html(args.item.evnt_cn);
				$("#evntDtl_evntCn2").html(args.item.evnt_cn2);
				let evntSeTitle = " 내용";
				if (args.item && args.item.evnt_se_nm) {
					let evntSeNm = (args.item.evnt_se_nm || "");
					if (evntSeNm.includes("/")) {
						evntSeTitle = evntSeNm.split("/")[0] + evntSeTitle;
					} else {
						evntSeTitle = evntSeNm.slice(2) + evntSeTitle;
					}
				} else {
					evntSeTitle = "이벤트" + evntSeTitle;
				}
				$("#titleEvntCn").text(evntSeTitle);

				if ($("#evntDetailBox").is(":hidden")) {
					toggleEvntDtlBox();
				}
				// 클릭된 행에 스타일 추가
				$("#eventList .jsgrid-table tr").removeClass("jsgrid-highlight-row");
				$(args.event.currentTarget).addClass("jsgrid-highlight-row");
			},
			onDataLoaded: function(args) {
				let data = args.data;
				for (let obj of data) {
					$("#eventList").jsGrid("updateItem", obj);
				}
			},
			controller: {
				loadData: function(filter) {
					return $.ajax ({
						type: "POST",
						contentType: "application/json; charset=utf-8",
						cache: false,
						url: "getEvntList2",
						dataType: "json",
						data: JSON.stringify(filter),
						success: function(response) {
							__dataObj["grdEventData"] = response;
						}
					});
				}
			}
		});

		$("#eventList .jsgrid-header-cell").resizable({
			handles: "e",
			minWidth: __dataObj["eventListMinWidth"],
			maxWidth: __dataObj["eventListMaxWidth"],
			resize: function(event, ui) {
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

		function clearDtl() {
			$("#evntDtl_evntSe").val("");
			$("#evntDtl_wrkr").val("");
			$("#evntDtl_bgngDt").val("");
			$("#evntDtl_endDt").val("");
			$("#evntDtl_procs").val("");
			$("#evntDtl_fclt").val("");
			$("#evntDtl_fcltDtl").val("");
			$("#evntDtl_evntCn").html("");
			$("#evntDtl_evntCn2").html("");
			$("#titleEvntCn").text("이벤트 내용");

			if ($("#evntDetailBox").is(":hidden")) {
				toggleEvntDtlBox();
			}
		};

		function showTooltipEvntCn(e, row) {
			// 이벤트 내용에 마우스 HOVER 이벤트
			const tooltip = document.getElementById("tooltip_text_" + row.evnt_id);
			tooltip.innerHTML = row.evnt_cn;
			tooltip.style.display = "block";
			if (e.clientY > (window.screen.availHeight / 2)) {
				tooltip.style.top = -1 * $("#tooltip_text_" + row.evnt_id).height();
				tooltip.classList.add("bttm");
			} else {
				tooltip.classList.remove("bttm");
				tooltip.style.top = 0;
			}
		};

		function hideTooltipEvntCn(evnt_id) {
			// 이벤트 내용에 마우스 HOVER 이벤트
			const tooltip = document.getElementById("tooltip_text_" + evnt_id);
			tooltip.style.display = "none";
		};

		// 공정 태그 목록 jsGrid 설정
		$("#procTagList").jsGrid({
			width: "99.6%",
			height: "99%",
			noDataContent: "No data.",
			editing: false,
			sorting: false,
			paging: true,
			pageSize: s_PageSize,
			data: [],
			fields: [
				{
					name: "ck",
					type: "text",
					width: 60,
					title: "",
					align: "center",
					sorting: false,
					itemTemplate: function(value, row) {
						//return `<label style="display: flex; justify-content: center; width: 100%; height: 100%;"><input type="checkbox" name="tagCk" value="\${row.tagNm}"></label>`;
						return `<input type="checkbox" name="tagCk" value="\${row.tagNm}">`;
					},
					headerTemplate: function() {
						return $("<input>").attr("type", "checkbox").attr("id", "tagCkAll").attr("onchange", "selectAllCheckbox(this.checked)");
					},
				}, {
					name: "tagNm",
					type: "text",
					width: 270,
					title: "태그명",
					align: "left"
				}, {
					name: "tagDesc",
					type: "text",
					width: 330,
					title: "태그 설명",
					align: "left",
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
				},
			],
			rowClick: function(args) {
				// 클릭된 행에 스타일 추가
				$("#procTagList .jsgrid-table tr").removeClass("jsgrid-highlight-row");
				$(args.event.currentTarget).addClass("jsgrid-highlight-row");

				args.event.currentTarget.querySelector("input[type='checkbox']").click();
				//document.getElementById("tagCkAll").checked = false;
			},
			onDataLoaded: function(args) {
			}
		});

		$("#procTagList .jsgrid-header-cell").resizable({
			handles: "e",
			minWidth: __dataObj["procTagListMinWidth"],
			maxWidth: __dataObj["procTagListMaxWidth"],
			resize: function(event, ui) {
				__dataObj["changeWidth"] = Number(__dataObj["startWidth"]) + (event.pageX - __dataObj["startX"]);
				if (__dataObj["changeWidth"] <= __dataObj["procTagListMinWidth"]) {
					__dataObj["changeWidth"] = __dataObj["procTagListMinWidth"];
				} else if (__dataObj["changeWidth"] >= __dataObj["procTagListMaxWidth"]) {
					__dataObj["changeWidth"] = __dataObj["procTagListMaxWidth"];
				}
				this.style.width = __dataObj["changeWidth"];
				let index = this.cellIndex;
				document.querySelectorAll(`#procTagList .jsgrid-cell:nth-child(\${index + 1})`).forEach(td => {
					td.style.width = __dataObj["changeWidth"];
				});
			},
			start: function(event, ui) {
				__dataObj["startWidth"] = this.style.width.replace("px", "");
				__dataObj["startX"] = event.pageX;
			},
			stop: function(event, ui) {
				let index = this.cellIndex;
				document.querySelectorAll(`#procTagList .jsgrid-cell:nth-child(\${index + 1})`).forEach(td => {
					td.style.width = __dataObj["changeWidth"];
				});
			}
		});

		function selectAllCheckbox(checked) {
			let cks = $("input[type='checkbox'][name='tagCk']");
			cks.each(function(index, item) {
				item.checked = checked;
			});
		};

		function getHstnTagList(obj) {
			$("#procTagList").jsGrid("option", "data", []);
			$.ajax ( {
				type: "POST",
				contentType: "application/json; charset=UTF-8",
				url: "getHstnTagList",
				dataType: "json",
				cache: true,
				data: JSON.stringify(obj),
				success: function(res) {
					grdProcData = new Array();
					for (let obj of res) {
						grdProcData.push({
							tagSn: obj.TAGSN,
							tagNm: obj.NODE_NM + "." + obj.TAG_ADDR,
							tagDesc: obj.TAG_DESC
						});
					}
					$("#procTagList").jsGrid("option", "data", grdProcData);
				},
				error: function(e) {
					MsgBox("Info", "태그 목록 조회에 실패하였습니다.");
				}
			});
		}

		// 팝업 태그 데이터 jsGrid 설정
		$("#popTagList").jsGrid({
			width: "99.8%",
			height: "50vh",
			noDataContent: "No data.",
			editing: false,
			sorting: false,
			paging: true,
			pageSize: s_PageSize,
			fields: [
				{
					name: "time",
					type: "text",
					width: 160,
					title: "태그 시간",
					align: "center",
					editing: false,
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
				},
			],
			rowDoubleClick: function(args) {
				// 선택된 row 표시
				$("#popTagList .jsgrid-table tr").removeClass("jsgrid-highlight-row");
				$(args.event.currentTarget).addClass("jsgrid-highlight-row");
			},
			rowClick: function(args) {
				// 클릭된 행에 스타일 추가
				$("#popTagList .jsgrid-table tr").removeClass("jsgrid-highlight-row");
				$(args.event.currentTarget).addClass("jsgrid-highlight-row");
			},
			onDataLoaded: function(args) {
			}
		});

		function getTagValues(tagList) {
			let obj = new Object();
			obj.cmd = "fetchValues";
			obj.dest = "historian";
			obj.timeout = 30000;
			obj.param = {};
			obj.param.start = $("#date1").val() + " " + $("#time1").val();
			obj.param.end = $("#date2").val() + " " + $("#time2").val();
			obj.param.fit = true;
			obj.param.tagList = tagList;
			postMessage("reqHistorian", obj, onFetchValues);
		};

		function onFetchValues(res) {
			if (res.cmd == "error") {
				let fields = $("#popTagList").jsGrid("option", "fields");
				let tagList = new Array();
				for (let field of fields) {
					if (field.name != "time") {
						tagList.push(field.name);
					}
				}
				if (tagList.length > 0) {
					getTagValues(tagList);
				}
			} else {
				let dataObj = new Object();
				for (let tagData of res) {
					let tag = tagData.name;
					for (let value of tagData.values) {
						let time = moment(value.time).format("YYYY-MM-DD HH:mm");
						if (!!!dataObj[time]) {
							dataObj[time] = {time: time};
						}
						dataObj[time][tag] = value.val;
					}
				}
				let data = new Array();
				for (let time in dataObj) {
					data.push(dataObj[time]);
				}
				$("#popTagList").jsGrid("option", "data", data);
			}
		};

		// 공정 태그 및 이벤트 목록 엔터 키 검색
		function onEnterSearch(event) {
			if (event.keyCode === 13) { // 엔터키(Enter)가 눌렸을 때
				let targetId = event.target.id; // 엔터키가 눌린 입력 필드의 ID를 확인
				if (targetId === "searchEventTag") {
					searchGrid1(); // 이벤트 목록 검색 함수 호출
				} else if (targetId === "searchProcTag" || targetId === "searchProcTagDesc") {
					searchGrid2(); // 공정 태그 목록 검색 함수 호출
				}
			}
		};

		// 이벤트 목록 검색 기능
		function searchGrid1() {
			if (!__dataObj["grdEventData"]) {
				return;
			}
			let filterValue = $("#searchEventTag").val().toLowerCase(); // 입력값 가져오기
			let filteredData = __dataObj["grdEventData"].filter(item => item.evnt_cn.includes(filterValue));
			// || (item.evnt_cn2 || "").includes(filterValue));

			$("#eventList").jsGrid("option", "data", filteredData); // 필터링된 데이터로 그리드 업데이트
			$("#eventList").jsGrid("refresh"); // 그리드 새로 고침
		};

		// 공정 태그 목록 검색 기능
		function searchGrid2() {
			let filterValue = $("#searchProcTag").val().toLowerCase(); // 입력값 가져오기
			let descValue = $("#searchProcTagDesc").val();
			getHstnTagList({searchwd: filterValue, search_desc: descValue});
		};

		function tggleSearchGroup(t) {
			// 조회박스에서 설비,설비 상세 보이기 안보이기
			$("#searchGrpFclt").toggle();
			$("#searchGrpFcltDtl").toggle();
			if ($("#searchGrpFclt").is(":visible")) {
				let fclt_list = new Array();
				$("input[name='fclt_ck']").each(function(index, item) {
					if (item.value != "*") {
						if (item.checked) {
							fclt_list.push(item.value);
						}
					}
				});
				let diff = fclt_list.length * 25;
				$("#dataBox").css("height", `calc(76% - \${diff}px)`);
				let imgdiv = t.querySelectorAll(".slide-down")[0];
				imgdiv.classList.add("slide-up");
				imgdiv.classList.remove("slide-down");
			} else {
				$("#dataBox").css("height", "76%");
				let imgdiv = t.querySelectorAll(".slide-up")[0];
				imgdiv.classList.add("slide-down");
				imgdiv.classList.remove("slide-up");
			}
			$("#eventList").jsGrid("refresh"); // 그리드 새로 고침
		};

		//---------------------------------------------- 자료조회 관련 시작 -----------------------------------------------------------------------------------------
		// 트렌트 팝업
		let trendObj = {
			tagList: []
		};

		function openPopupTrend() {
			trendObj.tagList = new Array();
			let cks = $("input[type='checkbox'][name='tagCk']");
			cks.each(function(index, item) {
				if (item.checked) {
					trendObj.tagList.push(item.value);
				}
			});
			window.open("trendView", "Trend", "width=1500; height=900; top: 200;", true);
		};

		// 자료조회 그리드 팝업
		function popTagGrid() {
			let tagList = new Array();
			let cks = $("input[type='checkbox'][name='tagCk']");
			cks.each(function(index, item) {
				if (item.checked) {
					tagList.push(item.value);
				}
			});
			let fields = $("#popTagList").data("JSGrid").fields;
			fields.splice(1);
			let cv = document.createElement("canvas").getContext("2d");
			cv.font = "18px NotoSansKR-Medium";

			for (let tagName of tagList) {
				let field = {};
				field.name = tagName;
				field.type = "text";
				field.title = tagName;
				field.align = "right";

				let width = cv.measureText(tagName).width;
				field.width = (width > 150 ? width : 150) + 20;
				fields.push(field);
			}
			$("#popTagList").jsGrid("option", "fields", fields);

			if (fields.length > 1) {
				getTagValues(tagList);
				// 다이얼로그 열기 및 타이틀 설정
				$("#procTagDlg").dialog("option", "title", "").dialog("open");
				// 기타 설정
				$(".ui-dialog .ui-dialog-buttonpane").addClass("border-none");
				$(".ui-widget-header").addClass("title-style ");
				$(".ui-button.ui-corner-all.ui-widget.ui-button-icon-only.ui-dialog-titlebar-close").remove();
				$(".ui-dialog-buttonset button:first-child").addClass("btnPopCancel");
				$(".ui-dialog-buttonset button:last-child").addClass("btnPopExcel");
				// $(".btnPopExcel").css("padding", 0);
			}
		};

		// 태그 그리드 팝업
		$("#procTagDlg").dialog({
			width: "max(500px, 50vw)",
			autoOpen: false,
			resizable: false,
			closeOnEscape: false,
			open: function() {
				// 팝업이 열릴 때 그리드 높이를 동적으로 설정
				$("#popTagList").jsGrid("option", "height", "50vh"); // 다이얼로그 높이에 맞추기

				$("#popTagList .jsgrid-header-cell").resizable({
					handles: "e",
					minWidth: __dataObj["popTagListMinWidth"],
					maxWidth: __dataObj["popTagListMaxWidth"],
					resize: function(event, ui) {
						__dataObj["changeWidth"] = Number(__dataObj["startWidth"]) + (event.pageX - __dataObj["startX"]);
						if (__dataObj["changeWidth"] <= __dataObj["popTagListMinWidth"]) {
							__dataObj["changeWidth"] = __dataObj["popTagListMinWidth"];
						} else if (__dataObj["changeWidth"] >= __dataObj["popTagListMaxWidth"]) {
							__dataObj["changeWidth"] = __dataObj["popTagListMaxWidth"];
						}
						this.style.width = __dataObj["changeWidth"];
						let index = this.cellIndex;
						document.querySelectorAll(`#popTagList .jsgrid-cell:nth-child(\${index + 1})`).forEach(td => {
							td.style.width = __dataObj["changeWidth"];
						});
					},
					start: function(event, ui) {
						__dataObj["startWidth"] = this.style.width.replace("px", "");
						__dataObj["startX"] = event.pageX;
					},
					stop: function(event, ui) {
						let index = this.cellIndex;
						document.querySelectorAll(`#popTagList .jsgrid-cell:nth-child(\${index + 1})`).forEach(td => {
							td.style.width = __dataObj["changeWidth"];
						});
					}
				});
			},
			buttons: {
				"취소": function() {
					$(this).dialog("close");
				},
				"엑셀 다운": function() {
					ExportExcel();
				}
			}
		});

		function ExportExcel() {
			let fileName = "태그자료.xlsx";
			let data = new Array();
			let rows = $("#popTagList").data("JSGrid").data;
			let fields = $("#popTagList").data("JSGrid").fields;
			let header = new Array();
			for (let i = 0; i < fields.length; i++) {
				header.push({v: fields[i].title, t: "s", s: {alignment: {vertical: "center", horizontal: "center"}, fill: { fgColor: {rgb: "F2F2F2"}}, font: {bold: true}}});
			}
			data.push(header);

			for (let i = 0; i < rows.length; i++) {
				let row = new Array();
				for (let j = 0; j < fields.length; j++) {
					let isString = true;
					let val = String(rows[i][fields[j].name]);
					if (j >= 1) {
						isString = false;
						val = Number(val.replace(/,/gi, ""));
						if (isNaN(val)) {
							isString = true;
							val = "-";
						}
					}

					let cell = {v: val};
					if (isString) {
						cell.t = "s";
						cell.s = {
							alignment: {vertical: "center", horizontal: "center"}
						};
					} else {
						cell.t = "n";
						cell.s = {
							alignment: {vertical: "center", horizontal: "right"},
						};
						cell.z = "#,##0.00";
					}
					row.push(cell);
				}
				data.push(row);
			}
			let wb = XLSX.utils.book_new();
			let newWorksheet = XLSX.utils.aoa_to_sheet(data);
			newWorksheet["!cols"] = [
				{wpx: 120 },
				{wpx: 120 },
			];
			XLSX.utils.book_append_sheet(wb, newWorksheet, "sheet1");
			let wbout = XLSX.write(wb, {bookType:"xlsx", type: "binary"});
			saveAs(new Blob([s2ab(wbout)],{type:"application/octet-stream"}), fileName);
		};

		function s2ab(s) {
			let buf = new ArrayBuffer(s.length); //convert s to arrayBuffer
			let view = new Uint8Array(buf); //create uint8array as viewer
			for (let i = 0; i < s.length; i++) {
				view[i] = s.charCodeAt(i) & 0xFF; //convert to octet
			}
			return buf;
		};

		//---------------------------------------------- 자료조회 관련 끝 -----------------------------------------------------------------------------------------
		function toggleEvntDtlBox() {
			$("#evntDetailBox").toggle();
			if ($("#evntDetailBox").is(":hidden")) {
				$("#btnEvntDtlBox").text("보기");
			} else {
				$("#btnEvntDtlBox").text("접기");
			}
			$("#eventList").jsGrid("refresh");
		};
	</script>
</body>
</html>