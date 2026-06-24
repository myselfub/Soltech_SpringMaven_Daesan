<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관제 화면 시안</title>


<style>
	html {overflow-y:hidden;}
	.contentBox_m {padding:0;}
	.navi-box {
		position: relative;
		display: flex;
		/* left: 40vw; */
		border: 1px solid #172D43;
		opacity: 1;
		z-index: 10;
		width: 100%;
		justify-content: center;
		background: #172D43;
		height: 3.5rem;
		top: 0;
		column-gap: 0.3rem;
	}

	.navi-contents {
		display: flex;
		justify-content: center;
		flex-direction: column;
	}

	.navi-path {
		cursor: pointer;
		padding: 0.65rem;
		width: 7.1rem;
		height: 2.75rem;
		text-align: center;
		background: #172D43;
		border-radius: 0.25rem;
		display: flex;
		justify-content: center;
		flex-direction: column;
	}

	.navi-path p {
		color: #FFFFFF;
		font-family: 'Pretendard-SemiBold';
	}

	.navi-path.active {
		background: #1674A8;
	}

	.navi-path:hover {
		background: #1674A8;
	}

	#contents {position: relative; top: -3.5rem; background: #172D43;}
</style>
</head>
<body>
	<div class="navi-box">
		<div class="navi-contents">
			<div class="navi-path active" id="1" onclick="onClickNavi(this.id);"><p>공정 메인</p></div>
		</div>
		<div class="navi-contents">
			<div class="navi-path " id="5" onclick="onClickNavi(this.id);"><p>평면도</p></div>
		</div>
		<div class="navi-contents">
			<div class="navi-path " id="3" onclick="onClickNavi(this.id);"><p>공정도</p></div>
		</div>
		<div class="navi-contents">
			<div class="navi-path " id="2" onclick="onClickNavi(this.id);"><p>계통도</p></div>
		</div>
	</div>
	<div id="contents"></div>
	<script>
		window.onload = function() {
			$("#contents").load("resources/html/contents1.html?time=" + (new Date()).format("yyyymmddhhmmss"), function () {
				init()
			});
		};

		$( window ).on("resize", function() {
			checkFullScreenMode();
		});

		function checkFullScreenMode() {
			if (window.innerHeight >= window.screen.availHeight) {
				$(".leftBox").hide();
				const width = window.innerWidth;
				const height = window.innerHeight; //document.body.clientHeight;

				$("#contents").width(width);
				$("#contents").height(height);
				$(".contentBox").width(width);
				$(".contentBox").height(height);
			} else {
				$(".leftBox").show();
				const width = window.innerWidth - 110;
				let height = window.innerHeight;// document.body.clientHeight;
				$("#contents").width(width);
				$("#contents").height(height);
				$(".contentBox").width(width);
				$(".contentBox").height(height);
			}
			let id = document.querySelectorAll(".navi-path.active")[0].id;
			drawBackground(id);
		};

		function onClickNavi(id) {
			$(".navi-path").each(function(index, item) {
				item.classList.remove("active");
			});
			$("#" + id).addClass("active");
			switch(id) {
				case "1": 
					$("#contents").load("resources/html/contents1.html?time="+(new Date()).format("yyyymmddhhmmss"), function(){
						checkFullScreenMode();
						$(".data-box").css("top", "3.5rem");
						$(".data-box").css("width", "100%");
						$(".data-box").css("height", "calc(100% - 3.5rem)");
					});
					break;
				case "2":
					$("#contents").load("resources/html/contents2.html?time="+(new Date()).format("yyyymmddhhmmss"), function(){
						checkFullScreenMode();
					});	
					break;
				case "3":
					$("#contents").load("resources/html/contents3.html?time="+(new Date()).format("yyyymmddhhmmss"), function(){
						checkFullScreenMode();
					});
					break;
				case "5":
					$("#contents").load("resources/html/contents5.html?time="+(new Date()).format("yyyymmddhhmmss"), function(){
						checkFullScreenMode();
					});
					break;
			}
		};

		let defInfo = {
			"1" : {
				background: "resources/images/view/db/db0103/contents1/bg/BG01.png",
				backDftWidth: 1810,
				backDftHeight: 945,
				contents: {
					"contentL":{width: 963, height: 808, left: 538, top: 131},
					"contentNT":{width: 1131, height: 801, left: 408, top: 128},
					"content1":{width: 590, height: 578, left: 161, top: 307},
					"content2":{width: 572, height: 292, left: 800, top: 600},
					"content3":{width: 476, height: 274, left: 1114, top: 228},
					"content4":{width: 178, height: 224, left: 1430, top: 520},
					"data1":{width: 378, height: 174, left: 230, top: 420},
					"data2":{width: 378, height: 174, left: 930, top: 530},
					"data3":{width: 496, height: 254, left: 1050, top: 70},
					"data4":{width: 378, height: 174, left: 1120, top: 350},
					"area01":{width: 30, height: 30, left: 1467, top: 198},
					"area02":{width: 50, height: 30, left: 1143, top: 866},
					"Adata":{width: 930, height: 777, left: 577, top: 117},
					"data-bar":{width: 307, height: 889, top: 0},
					"data-bar-btn-slide":{right: 307}
				}
			},
			"2" : {
				background: "resources/images/view/db/db0103/contents2/BG04.png",
				backDftWidth: 1810,
				backDftHeight: 945,
				contents: {
					"Cline":{width: 1717, height:592, left: 152, top: 79},
					"tag01":{width: 163, height:49, left: 218, top: 87},
					"tag02":{width: 167, height:49, left: 565, top: 87},
					"tag03":{width: 188, height:49, left: 789, top: 87},
					"tag04":{width: 190, height:49, left: 1180, top: 87},
					"tag05":{width: 190, height:49, left: 1440, top: 87},
					"tag06":{width: 201, height:49, left: 239, top: 614},
					"tag07":{width: 163, height:49, left: 1523, top: 614},
					"Thover01":{width: 374, height:197, left: 152, top: 139},
					"Thover02":{width: 275, height:197, left: 526, top: 139},
					"Thover03":{width: 399, height:322, left: 808, top: 139},
					"Thover04":{width: 269, height:197, left: 1170, top: 139},
					"Thover05":{width: 231, height:258, left: 1433, top: 139},
					"Thover06":{width: 698, height:197, left: 179, top: 414},
					"Thover07":{width: 637, height:197, left: 1058, top: 414},
					"Cdata1":{width: 27, height:30, left: 421, top: 232},
					"Cdata1_tooltip":{width: 254, height:280, left: 455, top: 172},
					"Cdata2":{width: 27, height:30, left: 1039, top: 242},
					"Cdata2_tooltip":{width: 254, height:216, left: 1085, top: 206},
					"Cdata3":{width: 27, height:30, left: 1135, top: 358},
					"Cdata4":{width: 27, height:30, left: 1384, top: 228},
					"Cdata5":{width: 27, height:30, left: 475, top: 495},
					"Cdata6":{width: 27, height:30, left: 744, top: 495},
					"Cdata7":{width: 27, height:30, left: 1283, top: 488},
					"Gdata1":{width: 130, height:169, left: 310, top: 748},
					"Gdata2":{width: 130, height:169, left: 487, top: 748},
					"Gdata3":{width: 130, height:169, left: 658, top: 748},
					"Gdata4":{width: 130, height:169, left: 846, top: 748},
					"Gdata5":{width: 130, height:169, left: 1035, top: 748},
					"Gdata6":{width: 130, height:169, left: 1210, top: 748},
					"Gdata7":{width: 130, height:169, left: 1385, top: 748},
					"Gdata8":{width: 130, height:169, left: 1562, top: 748},
					"Gdata9":{width: 130, height:169, left: 1732, top: 748},
				}
			},
			"3" : {
				background: "resources/images/view/db/db0103/contents3/BG03.png",
				backDftWidth: 1810,
				backDftHeight: 945,
				contents: {
					"Cflow1":{width: 176, height: 168, left: 180, top: 76},
					"Cflow2":{width: 174, height: 168, left: 394, top: 76},
					"Cflow3":{width: 176, height: 168, left: 606, top: 76},
					"Cflow4":{width: 176, height: 168, left: 820, top: 76},
					"Cflow5":{width: 173, height: 168, left: 1035, top: 76},
					"Cflow6":{width: 184, height: 166, left: 1243, top: 227},
					"Cflow7":{width: 177, height: 168, left: 1246, top: 76},
					"Cflow8":{width: 174, height: 168, left: 1461, top: 76},
					"Cflow9":{width: 176, height: 168, left: 1673, top: 76},
					"Cflow_data1":{width: 422, height: 182, left: 160, top: 252},
					"Cflow_data2":{width: 343, height: 214, left: 310, top: 252},
					"Cflow_data3":{width: 350, height: 150, left: 520, top: 252},
					"Cflow_data4":{width: 278, height: 214, left: 770, top: 252},
					"Cflow_data5":{width: 296, height: 142, left: 974, top: 252},
					"Cflow_data7":{width: 214, height: 182, left: 1228, top: 252},
					"Cflow_data8":{width: 214, height: 182, left: 1441, top: 252},
					"Cflow_data9":{width: 201, height: 118, left: 1660, top: 252},
					"content1":{width: 241, height: 152, left: 486, top: 423},
					"content2":{width: 243, height: 152, left: 755, top: 420},
					"content3":{width: 239, height: 149, left: 1032, top: 420},
					"content4":{width: 239, height: 149, left: 1305, top: 420},
					"content5":{width: 239, height: 149, left: 1575, top: 420},
					"Cdata1":{width: 936, height: 424, left: 720, top: 398},
					"Cdata2":{width: 920, height: 422, left: 990, top: 398},
					"Cdata3":{width: 764, height: 629, left: 285, top: 309},
					"Cdata4":{width: 765, height: 801, left: 559, top: 138},
					"label1": {width: 74, height: 31, left: 155, top: 584},
					"label2": {width: 74, height: 31, left: 233, top: 584},
					"image-container": {width: 1736, height: 307, left:153, top: 618},
					"popup_1": {width: 162, height: 200, left:193, top: 77},
					"content1-gif": {width: 120, height: 19, left:316, top: 177},
					"content2-gif": {width: 120, height: 19, left:535, top: 177},
					"content3-gif": {width: 120, height: 19, left:745, top: 177},
					"content4-gif": {width: 120, height: 19, left:957, top: 177},
					"content5-gif": {width: 120, height: 19, left:1170, top: 177},
					"content6-gif": {width: 120, height: 19, left:1387, top: 177},
					"content7-gif": {width: 120, height: 19, left:1593, top: 177},
					"content8-gif": {width: 120, height: 19, left:1168, top: 248},
					"content9-gif": {width: 120, height: 19, left:1384, top: 248},
					"content10-gif": {width: 120, height: 19, left:1231, top: 326},
					"content11-gif": {width: 120, height: 19, left:1317, top: 326},
				}
			},
			"5": {
				background: "resources/images/view/db/db0103/contents5/BG02.png",
				backDftWidth: 1810,
				backDftHeight: 945,
				contents: {
					"content02NT": {width: 437, height: 786, left: 1425, top: 123},
					"content1": {width: 312, height: 230, left: 176, top: 110},
					"content2": {width: 325, height: 238, left: 550, top: 100},
					"content3": {width: 325, height: 238, left: 931, top: 100},
					"content4": {width: 343, height: 237, left: 159, top: 512},
					"content5": {width: 350, height: 236, left: 541, top: 525},
					"content6": {width: 335, height: 230, left: 927, top: 518},
					"Chover1": {width: 246, height: 168, left: 1436, top: 177},
					"Chover3": {width: 300, height: 229, left: 1315, top: 335},
					"Chover4": {width: 192, height: 162, left: 1627, top: 233},
					"Chover5": {width: 262, height: 158, left: 1598, top: 368},
					"Chover6": {width: 196, height: 113, left: 1618, top: 798},
					"Ctext1": {width: 350, height: 150, left: 1309, top: 614},
					"Ctext2": {width: 214, height: 182, left: 1309, top: 598},
					"Ctext3": {width: 214, height: 182, left: 1309, top: 598},
					"Ctext4": {width: 296, height: 142, left: 1309, top: 618},
					"Ctext5": {width: 278, height: 214, left: 1309, top: 582},
					"Ctext6": {width: 201, height: 118, left: 1309, top: 630},
					"hoverBG": {width: 584, height: 829, left: 1299, top: 86},
				}
			}
		};

		function drawBackground(id) {
			let canvas = document.getElementById("Graphics");
			canvas.width = $(".contentBox").width();
			canvas.height = $(".contentBox").height();
			let context = canvas.getContext("2d");
			let image = new Image();
			image.src = defInfo[id].background;
			image.onload = function() {
				let rect = canvas.getBoundingClientRect();
				context.drawImage(image, 0, 0, rect.width, rect.height);
				for (let eleId in defInfo[id].contents) {
					calcZoomRatio(id, eleId, rect);
				}
			}
		};

		function calcZoomRatio(id, eleId, rect) {
			let contentH1 = document.getElementsByClassName(eleId)[0];
			if (!!contentH1) {
				let width = rect.width;
				let height = rect.height;

				let zoomRatioX = width / defInfo[id].backDftWidth;
				let zoomRatioY = height / defInfo[id].backDftHeight;

				//zoomX: zoomRatioX, zoomY: zoomRatioY, zoom: Math.min(zoomRatioX, zoomRatioY)

				contentH1.style.width = defInfo[id]["contents"][eleId].width * zoomRatioX;
				contentH1.style.height = defInfo[id]["contents"][eleId].height * zoomRatioY;
				contentH1.style.left = (defInfo[id]["contents"][eleId].left * zoomRatioX) - $(".leftBox").width();
				contentH1.style.right = (defInfo[id]["contents"][eleId].right * zoomRatioX);

				if (window.innerHeight >= window.screen.availHeight) {
					if (eleId == "data-bar") {
						//contentH1.style.left = 0;
					}
					if (eleId === "content8-gif" || eleId === "content9-gif") {
						contentH1.style.left = (defInfo[id]["contents"][eleId].left * zoomRatioX) - $(".leftBox").width() - 6;
					}
				}
				contentH1.style.top = (defInfo[id]["contents"][eleId].top * zoomRatioY);	
			}
		};

		function showPop(id, option) {
			window.open("popup/db/" + id, "_blank", option);
		};
	</script>
</body>
</html>