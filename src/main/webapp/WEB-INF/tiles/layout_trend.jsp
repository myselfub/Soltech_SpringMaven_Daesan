<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page session="true" %>
<html>
	<head>
		<title>대산해수담수화</title>
		<link rel="icon" type="image/x-icon" href="<%=request.getContextPath()%>/resources/images/com/favicon.png">
		
		<script src="<%=request.getContextPath()%>/resources/js/jquery/jquery-3.5.1.min.js"></script>
		<script src="<%=request.getContextPath()%>/resources/js/jquery/jquery.validate.min.js"></script>
		<script src="<%=request.getContextPath()%>/resources/js/jquery-ui/jquery-ui.min.js"></script>
		<script src="<%=request.getContextPath()%>/resources/js/jsgrid/jsgrid.js"></script>
		
		<script src="<%=request.getContextPath()%>/resources/js/sheetJS/xlsx.full.min.js"></script>
		<script src="<%=request.getContextPath()%>/resources/js/FileSaver.min.js"></script>
		<script src="<%=request.getContextPath()%>/resources/js/biznexus/bizManagerCommon.js"></script>
		<script src="<%=request.getContextPath()%>/resources/js/biznexus/biztrend.js"></script>
		
		<link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/resources/js/jsgrid/jsgrid.min.css" />
		<link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/resources/js/jsgrid/jsgrid-theme.min.css" />
		<link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/resources/js/jquery-ui/jquery-ui.min.css"> 
		<link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/resources/js/jquery-ui/jquery-ui.theme.min.css">
		
		<link rel="stylesheet" href="<%=request.getContextPath()%><tiles:getAsString name = "page_css"/>"/>
		
		<style>
			#table-main {
				table-layout: fixed;
				width:100%;
				height: auto;
			}
			
			#table-main th{
				font-size: 14px;
			}
			
			#table-main td {
				vertical-align : top;
				font-size: 14px;
				overflow:hidden;
			}
			h3:hover {
				cursor : Pointer;
			}
			
			#main{
				position: absolute;
				width: 100%;
				height: 100%;
				background: #000;
				top: 0;
				left: 0;
				margin: 0px;
			}
				
			.trdSearchBox{
				/* 가운데 경계 */
				width: auto;
				display: flex;
				justify-content: end;
				padding: 10px 35px;
				margin: 10px 0;
				background: #314257; 
			}
			
			label{
				color: #fff;
			}
			
			.btnHidden{
				/*태그 목록 보이기/숨기기 화살표 이미지*/
				width: 14px;
				height: 14px;
				margin: 0 1.5vh;
			}
			
			#tabe-tagAttr tr{
				/* 태그 설정 팝업 tr 높이*/
				height: 35px;
			}
			
			#modTimeDlg, #modSpanDlg{
				display: flex;
				align-items: flex-end;
				justify-content: center;
			}
			
			input[readonly="readonly"]{
				background-color: #e8e8e8;
				color: #999;
			}
			
			#tabe-tagAttr tr td:nth-child(1){
				padding-right: 5px;
			}
			 
			/* 메뉴 숨김 */
			.headerContainer {
				display: none;
			}
		</style>
	</head>
	<body>
		<div id="main">
			<table id="table-main">
				<tr>
					<td width="100%" height="10px;"></td>
				</tr>
				<tr>
					<td>
						<canvas id="trend" style ="width:100%;height:67vh;padding:0;"></canvas>
					<td>
				</tr>
				<tr>
					<td align="right" style='background: #000;'><img class='btnHidden' onclick='toggleTagList();' src="<%=request.getContextPath()%>/resources/images/biznexus/down.png"></td>
				</tr>
				<tr >
					<td align="center">
						<div id="trendTagList" style="margin: 1.5vh"></div>
					</td>
				</tr>
			</table>
		</div>
		
		<div id="tagListDlg">
			<select id="category" class="comSel" style="width:12vw;" onchange="OnChangeCategory()">
				<option value='1'>이름</option>
				<option value='2'>설명</option>
				<option value='3'>드라이버</option>
				<option value='4' selected>위치</option>
			</select>
			<select id="val" class="comSel" style="width:max(12vw, 200px);"></select>
			<input type='button' class='btnSearch' value='검색' onclick='loadTagList();'></input>
			<div id="tagList" style="height:100%;"></div>
		</div>
		
		<div id="tagAttr" align="header">
			<table id="tabe-tagAttr">
				<tr>
					<td align="right">보이기(E) :</td>
					<td>
						<input type="checkbox" id="enable">
					<td >
				</tr>
				<tr>
					<td align="right">태그 이름 :</td>
					<td id="tagName"/>
					<td id="tagDesc">
				</tr>
				<tr>
					<td align="right">구역(Z) :</td>
					<td>
						<input type="number" id="index" min="1" max="4" style="width:50px;height:30px;">
					<td >
				</tr>
				<tr>
					<td align="right">차트 타입 :</td>
					<td>
						<select id="lineType" style="width:200px;height:30px;">
							<option value=1> Line chart </option>
							<option value=2> Step chart </option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">선 색상 :</td>
					<td>
						<input type="color" id="lineColor" style="width:100px;height:30px;" readonly>
					</td>
				</tr>
				<tr>
					<td align="right">스케일 :</td>
					<td>
						<input type="text" id="scaleMin" style="width:100px;height:30px;">
						~
						<input type="text" id="scaleMax" style="width:100px;height:30px;">
						<input type="checkbox" id="autoScale" onchange="onChangeAutoScale()" style="position: relative; top: 1px;">
						<label for="autoScale" style="color: #000; position:relative; top: -3px;">자동(A)</label>
					</td>
				</tr>
			</table>
		</div>
		<script>
			const s_url = 'reqHistorian';
			// url호출 부분 404 에러시 아래 주석 풀기
			//const s_url = 'req-tag';

			let m_stAreaList = new Set();
			
			window.onload = function()	{
				document.addEventListener('contextmenu', event => event.preventDefault());
				$("#trend").bizTrend({
					span : 24 * 3600,
					//theme : "white",
					onTaglistChanged: function(tagList) {
						let tagData = new Array();
						for(let tagName in tagList) {
							// khr : 소수2자리통일
							tagList[tagName].min = Math.round(tagList[tagName].min * 100) / 100; 
							tagList[tagName].max = Math.round(tagList[tagName].max * 100) / 100;
							let value = (typeof(tagList[tagName].val) == "string" ? (tagList[tagName].val).replaceAll(",","") : tagList[tagName.val]);
							tagList[tagName].val = Math.round(Number(value) * 100) / 100; 
							
							tagData.push(tagList[tagName]);
						}
						$("#trendTagList").jsGrid("option", "data", tagData);
					},
					
					onValueChanged : function(tagList) {
						let tagData = new Array();
						for(let tagName in tagList) {
							// khr : 소수2자리통일
							tagList[tagName].min = Math.round(tagList[tagName].min * 100) / 100; 
							tagList[tagName].max = Math.round(tagList[tagName].max * 100) / 100; 
							let value = (typeof(tagList[tagName].val) == "string" ? (tagList[tagName].val).replaceAll(",","") : tagList[tagName.val]);
							tagList[tagName].val = Math.round(Number(value) * 100) / 100;  
							
							tagData.push(tagList[tagName]);
						}
						$("#trendTagList").jsGrid("option", "data", tagData);
					},
					
					onSizeChanged : function(isFullscreen) {
						
						if(isFullscreen == true) { 
							$("#headerMenu").hide();
							$("#SideMenu").hide();
						}
						else {
							$("#headerMenu").show();
						}
					}
				});
				
				$("#trend").bizTrend("refreshMode", true); 
				setBizTrend();
			}
			
			async function getTagDesc(tagList){
				if(tagList.length > 0){
					Loading.start();
					let tagInfos = new Array();
					for(let tagname of tagList){
						
						let tagInfo = await reqGetByName(JSON.stringify({searchwd: tagname}));
						
						if(tagInfo != undefined && tagInfo.length > 0){
							let tag = {};
							tag.select = true;
							tag.name = tagInfo[0].TAG_NM;
							tag.desc = tagInfo[0].TAG_ADIT_DC;
							
							tagInfos.push(tag);		
						}
					}
					
					console.log(tagInfos)
					if(tagInfos.length > 0){
						$("#trend").bizTrend("setTagList", tagInfos);
						Loading.stop();
					}else{
						Loading.stop();
						console.log('조회 실패', obj);
					//	alert("조회 가능한 데이터가 없습니다.");
					}
				}
			}
			
			 function reqGetByName(reqData){
				return new Promise((resolve, reject) => {
					$.ajax (
					{
					    type: 'POST',
					    url: 'getHstnTagList',
					    dataType: 'json',
					    cache : false,
						contentType: "application/json; charset=UTF-8",
					    data: reqData,
					    success: function (obj) 
					    {	
					    	resolve(obj);
						},
						error: function (request, status, error) 
						{
							Loading.stop();
							console.log("Error" +  "[" + status + "]" + error);
							reject(error);
						}
					});
				});
			}
			
			setBizTrend = function(){
				let obj = [];
					if(opener.obj.tagList.length == 0){
						obj = opener.$("#Graphic").data("BizRender").selectedTags();
						
					}else{
						obj = opener.obj.tagList;
						console.log(obj);
					}
				toggleTagList();
				getTagDesc(obj);	
			}
			
			onChangeSize = function() {
				$("#trend").bizTrend("refresh");					
			}
			
			OnSelectTags = function(tagList) {
				let tagInfos = new Array();
				for(let tagInfo of tagList) {
					let tag = {};
					tag.select = false;
					tag.name = tagInfo.name;
					tag.desc = tagInfo.desc;
					
					tagInfos.push(tag);
				}
				
				$("#tagList").jsGrid("option", "data", tagInfos);
		     	$("#tagList").jsGrid("sort", "name", "asc");
			}
			
			setGrid = function(tagList) {
				for(var i = 0; i < tagList.length; i++)	
					tagList[i].valueType = s_ValueType[tagList[i].valType];
				
				$("#trendTagList").jsGrid("option", "data", tagList);
			}
			
			onChangeAutoScale = function() {
				if($("#autoScale").is(':checked') == true) {
					 $("#scaleMin").attr("readonly", true);
					 $("#scaleMax").attr("readonly", true);
				}
				else {
					 $("#scaleMin").removeAttr("readonly");
					 $("#scaleMax").removeAttr("readonly");
				}
			}

			Loading = {
					start: function() {
						return new Promise(function(resolve, reject) {
					   		if (document.getElementById('loading')) {
					   			setTimeout(function(){
					   				resolve();	   				
					   			},1);
					   			return;
					   		}
					   		$("#loadingBackground").show()
					   		var ele = document.createElement('div');
					   		ele.setAttribute('id', 'loading');
					   		ele.setAttribute('class', 'loading');
					   		
							var image = document.createElement('img');
							image.setAttribute('id', 'loading-image');
							image.setAttribute('src', getContextPath() + "/resources/images/biznexus/loading.gif");
							image.setAttribute('alt', "Loading...");
							
					   		ele.appendChild(image);
					   		
					   		var span = document.createElement('span');
					   		span.setAttribute('id', 'loading-stts');
					   		ele.appendChild(span);
					   		
					   		document.body.append(ele);
					   		setTimeout(function(){
				   				resolve();	   				
				   			},1);
						});
					},
					stop: function() {
				   		var ele = document.getElementById('loading');
				   		if (ele) {
				   			ele.remove();
				   		}
				   		$("#loadingBackground").hide()
					},
					stts: function(txt){
						return new Promise(function(resolve, reject) {
							var ele = document.getElementById('loading-stts');
					   		if (ele) {
					   			ele.innerText = txt;
					   			
					   		}
					   		setTimeout(function(){
				   				resolve();	   				
				   			},1);
						});
					}
				}
//-----------------------------------------------------------------------------------------------------------------------------------
			
			loadTagList = function() {
				let nCategory = $('#category option:selected').val();
				let strVal = $('#val option:selected').val();
				let strTxt = $('#val').val();
				
				switch(nCategory)
				{
					case '1': selectTags(s_url, SELECT_CATEGORY.BY_NAME, strTxt);break;
					case '2': selectTags(s_url, SELECT_CATEGORY.BY_DESC, strTxt);break;
					case '3': selectTags(s_url, SELECT_CATEGORY.BY_DRIVER, strVal);break;
					case '4': selectTags(s_url, SELECT_CATEGORY.BY_AREA, strVal);break;
				}
			}
			var OnChangeCategory = function() {
				$("#tagList").jsGrid("option", "data", []);
				
				var element = $("#category");
				$("#val").remove();

				var val = element.val();
				if(val == '3' || val == '4'){
					element.after('<select id="val" style="width:max(12vw, 200px);margin-left:5px"></select>');
					if(val == '3')
						getDrivers(s_url);
					else
						getAreas(s_url);
				}
				else
					element.after('<input type="text" id="val" style="width:max(12vw, 200px);margin-left:5px"></input>');
			}	
			
			fillDrivers = function(selector) {
				selector.children('option').remove();
				for(let drvName of m_stDriverList)	{
					selector.append("<option value='" + drvName + "'>" + drvName + "</option>");
				}
			}
			fillAreas = function(selector) {
				selector.children('option').remove();
				for(let area of m_stAreaList)	{
					selector.append("<option value='" + area + "'>" + area + "</option>");
				}
			}
			
			OnAreas = function(areaList) {
				m_stAreaList.clear();
				for(let area of areaList)
					m_stAreaList.add(area);
				
				fillAreas($("#val"));
				loadTagList();
			}
			OnDrivers = function(drvList) {
				m_stDriverList.clear();
				for(let drv of drvList)
					m_stDriverList.add(drv);
				
				var val = $("#category").val();
				if(val == '3') {
					fillDrivers($("#val"));
					loadTagList(s_url);
				}
			}
			
//-----------------------------------------------------------------------------------------------------------------------------------			
		
	        showTagAttrDlg = function(dialogType, tag) {
		     	if(typeof(tag) != "undefined") 	{
		     		let lineColor = tag.color.substring(0,7);
		     		
		     		$("#enable").prop('checked', tag.enable);
	    	   		$("#lineColor").val(lineColor);
					$("#tagName").text(tag.name);
	    	   		$("#tagDesc").val(tag.desc);
	    	   		$("#index").val(tag.index); // zone
		     		$("#autoScale").prop('checked', tag.autoScale);
		     		$("#lineType").val(tag.type);
	    	   		$("#scaleMin").val(tag.scaleMin);
	    	   		$("#scaleMax").val(tag.scaleMax);
	    	   		
		     		onChangeAutoScale();
	       		}
		     	$("#backscreen").show();
		     	$("#tagAttr").dialog("option", "title", "Tag attributes").dialog("open");
			};
    		
			isSelected = function(tagName) {
    			let ret = false;
    			
    			let trendTagList = $("#trendTagList").data("JSGrid").data;
    			for(let tag of trendTagList) {
    				if(tag.name != tagName) continue;
    				ret = true;
    				break;
    			}
    			
    			return ret;
    		}
    		
    		  $("#trendTagList").jsGrid({
  				width: "calc(100vw-3vh)",
  	            height: "25vh",
  	            editing: true,
  	            rowClick: function(args) {
  	            	showTagAttrDlg("Edit", args.item);
  				},
  	            onItemUpdated : function() {
  	            	
	  	            $("#trend").bizTrend("refresh");   	            		
  	            },
  	            deleteConfirm: function(item) { 
  	              	return "'" + item.name + "' 태그를 삭제하시겠습니까?";
                  },
                  onItemDeleted: function(args) {
		                $("#trend").bizTrend("delTag", args.item.name);                 		  
                  },
  				fields: 
  				[
  	   	        	{ name: "enable", type: "checkbox", width: 30, title :"E", align: "center" , editing: true },
  	  	            { 
  	   	        		name: "color", type: "text", width: 50, title: "색상",  align: "center", editing: false, 
  	   	        		itemTemplate : function(value, item) {
  	   	        			return "<div style='background-color:" + value + "'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp</div>";
  	   	        		}
  	  	            },
  	  	            { 
  	  	            	name: "type", type: "select",
  	  	              	items: [ { Name: "Line chart", Id: 1 }, { Name: "Step chart", Id: 2 } ],
  	  	           		valueField: "Id",
  	  	            	width: 80,
  	  	            	textField: "Name",
  	  	            	title: "타입",  align: "center", editing: true 
  	  	            },
  	  	            { name: "name", type: "text", width: 200, title: "태그 이름",  align: "header", editing: false },
  	              	{ name: "desc", type: "text", width: 300, title: "태그 설명",  align: "header", editing: false },
  	              	{ name: "index", type: "text", width: 30, title: "Z",  align: "center", editing: false },
  	              	{ name: "autoScale", type: "checkbox", width: 30, title: "A",  align: "center", editing: false },
  	              	{ name: "scaleMin", type: "number", width: 100, title: "최소 스케일",  align: "center", editing: false,
  	              		itemTemplate : function(value, item) {
  	              			if(value == undefined) return "-";
  	              			
 	              			if(item.enable) return value;
 	              			else return "-";
  	              			
	   	        		}
  	              	},
  	              	{ name: "scaleMax", type: "number", width: 100, title: "최대 스케일",  align: "center", editing: false,
	  	              	itemTemplate : function(value, item) {
		              			if(value == undefined) return "-";
		              			
		              			if(item.enable) return value;
		              			else return "-";
		              			
	   	        		}
  	              	},
  	              	{ name: "min", type: "number", width: 100, title: "최소값",  align: "right", editing: false,
	  	              	itemTemplate : function(value, item) {
		              			if(value == undefined) return "-";
		              			
		              			if(item.enable) return value;
		              			else return "-";
		              			
	   	        		}	
  	              	},
  	              	{ name: "max", type: "number", width: 100, title: "최대값",  align: "right", editing: false,
	  	              	itemTemplate : function(value, item) {
		              			if(value == undefined) return "-";
		              			
		              			if(item.enable) return value;
		              			else return "-";
		              			
	   	        		}
  	              	},
  	              	{ name: "time", type: "text", width: "*", title: "연월일",  align: "center", editing: false,
	  	              	itemTemplate : function(value, item) {
		              			if(value == undefined) return "-";
		              			
		              			if(item.enable) return value;
		              			else return "-";
		              			
	   	        		}
  	              	},
  	              	{ name: "val", type: "number", width: 100, title: "값",  align: "right", editing: false,
	  	              	itemTemplate : function(value, item) {
		              			if(value == undefined) return "-";
		              			
		              			if(item.enable) return value;
		              			else return "-";
		              			
	   	        		}	
  	              	},
  	              	{ type: "control", width:30, title: "Control", editButton: false, deleteButton : true },
  				]
  			});
			
    		 $("#trendTagList").on({
  				mouseenter : function() {
  			        let item = $(this).data("JSGridItem");
  			        
  			        let tagName = "*";
  			        if(typeof(item) != 'undefined') tagName = item.name;
  			        
  					$("#trend").bizTrend("setFocus", tagName);  			    	  
  				},
  				mouseleave : function() {
  					$("#trend").bizTrend("setFocus", "*");  						
  				}
  			}, "tr");
    		 
    		 $("#trendTagList").on({
   				mouseenter : function() {
   			        let cv = document.createElement('canvas').getContext("2d");
   			        cv.font = '16px NotoSansKR-Regular';
   			        let width = cv.measureText(this.innerHTML).width;
   			        
   			        if(width > $(this).width()){
   			        	this.setAttribute('title', this.innerHTML);	
   			        }			    	  
   				},
   				mouseleave : function() {					
   				}
   			}, "td");
			
			
    		  $("#tagList").jsGrid({
  				width: "100%",
  	            height: "60vh",
  	            sorting: true,
  	            paging: true,
                  pageSize: 1000,
                  pageButtonCount : 5,
  	            rowClick: function(args) {
  	            	args.item.select = args.item.select  == false ? true :false;
  	            	$("#tagList").jsGrid("updateItem", args.item);
  				},
  				fields: 
  				[
  	   	        	{ name: "select", type: "checkbox", width: 30, title :"", align: "center" , editing: true },
  	  	            { name: "name", type: "text", width: 200, title: "태그 이름",  align: "header", editing: false },
  	              	{ name: "desc", type: "text", width: 300, title: "태그 설명",  align: "header", editing: false }
  				]
  			});
 
    		  findRow = function(tagName) {
      			var tag = null;
  				var rows = $("#trendTagList").data("JSGrid").data;
  				
  				for(var i = 0; i < rows.length; i++) {
  					if(rows[i].name != tagName) continue;
  					tag = rows[i];
  					break;
  				}
  				
  				return tag;
      		}
  			
  			modifyAttr = function() {
  				let tag = findRow($('#tagName').text());
  				tag.enable = $('#enable').is(':checked');
  				tag.index =  $('#index').val();
  				tag.color =  $('#lineColor').val();
  				tag.type = Number($("#lineType").val());

  				tag.autoScale = $('#autoScale').is(':checked'); 
  				tag.scaleMin = $('#scaleMin').val();
  				tag.scaleMax = $('#scaleMax').val();
  			
  				$("#trendTagList").jsGrid("updateItem", tag);
  			}
  				
				
  			$("#tagAttr").dialog({
				autoOpen: false,
				resizable:false,
				closeOnEscape: false,
				width: 460,
				buttons: {
					"수정": function() {
						modifyAttr();
						$("#backscreen").hide();
						$(this).dialog("close");
					},
					"취소": function() {
						$("#backscreen").hide();
						$(this).dialog("close");
					}
				}
            });
  			
  			setTagList = function() {
				let tagList = $("#tagList").data("JSGrid").data;
				
				let tagInfos = new Array();
				for(let tagInfo of tagList) {
					if(tagInfo.select == false) continue;
					
					let tag = {};
					tag.name = tagInfo.name;
					tag.desc = tagInfo.desc;
					
					tagInfos.push(tag);					
				}
				$("#trend").bizTrend("setTagList", tagInfos);
			}

  			$("#tagListDlg").dialog({
				autoOpen: false,
				resizable:false,
				closeOnEscape: false,
				width: "max(700px, 50vw)",
				buttons: {
					"확인": function() {
						setTagList();
						$("#backscreen").hide();
						$(this).dialog("close");
					},
					"취소": function() {
						$("#backscreen").hide();
						$(this).dialog("close");
					}
				}
            });
			
			addTags = function() {
				$("#backscreen").show();
		     	$("#tagListDlg").dialog("option", "title", "태그 목록").dialog("open");
			}
		 
			toggleTagList = function() {
				$('#trendTagList').is(':visible') == true ? 
						[$(".btnHidden").attr("src",  getContextPath() + "/resources/images/biznexus/up.png"), $(".btnHidden").val("보이기")]
						: [$(".btnHidden").attr("src", getContextPath() + "/resources/images/biznexus/down.png"), $(".btnHidden").val("숨기기")];
				$("#trendTagList").toggle();
				$("#trend").css("height", $('#trendTagList').is(':visible') == true ? "67vh" : "94vh"); 
				
				$("#trend").bizTrend("refresh");										
			}
			
			$(".ui-dialog-buttonset button:first-child").addClass("btnSave");
			$(".ui-dialog-buttonset button:nth-child(2)").addClass("btnExcel");
			$(".ui-dialog-buttonset button:last-child").addClass("btnCancel");
			$(".ui-dialog-titlebar-close").remove();
        </script>
	</body>
</html>