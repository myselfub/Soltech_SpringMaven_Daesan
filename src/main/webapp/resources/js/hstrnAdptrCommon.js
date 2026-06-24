function makeFetchValuesObj(tagList, start, end){
	// 기간데이터 요청 파라미터 만들기
	let obj = {
		"cmd": "fetchValues",
		"param": {
			"tagList": tagList,
			"start": start, // 'YYYY-MM-DD HH:mm:ss'
			"end": end// 'YYYY-MM-DD HH:mm:ss'
		}
	};
	
	return obj;
}

function getFetchValues(obj){
	// 기간 데이터 불러오기
	return new Promise((resolve, reject)=>{
		$.ajax ({
			type: 'POST',
			contentType: 'application/json; charset=utf-8',
			cache : false, 
			url: 'reqHistorian',
			dataType: 'json',
			data: JSON.stringify(obj),
			success: function(data) {
				console.log(data);
				
				resolve(data);
			},
			error: function(e){
				console.log(e);
				reject();
			}
		});
	});
}

function makeWriteHistorianValuesObj(req){
	/* req : [
			{tag_nm: "TEST01", time: "2024-09-25 13:49:00", val: "25"},
			{tag_nm: "TEST01", time: "2024-09-25 13:50:00", val: "27"},
			{tag_nm: "TEST02", time: "2024-09-25 13:50:00", val: "21"}
		]
	
	*/
	
	let tempObj = new Object();
	
	for(let r of req){
		if(tempObj[r.tag_nm] == undefined){
			tempObj[r.tag_nm] = new Array();
		}
		
		tempObj[r.tag_nm].push({"time": r.time, "val": (r.val).toString(), "type": "float"});
	}
	
	let tagList = new Array();
	for(let tag_nm in tempObj){
		let values = new Array();
		for(let value of tempObj[tag_nm]){
			values.push(value);
		}
		
		tagList.push({name: tag_nm, values: values});
	}
	
	let obj =  {
		"cmd": "putValues",
		"param": {
			"tagList": tagList
		}
	};
	
	return obj;
}


/*

function getReqValues(){
			// 최신 데이터 불러오기
			return new Promise((resolve, reject)=>{
				let obj = {
					"cmd": "reqValues",
					"param": {
						"tagList": [
							"TEST01",
							"TEST02",
							"TEST04"
						]
					}
				};
				
				$.ajax ({
					type: 'POST',
					contentType: 'application/json; charset=utf-8',
					cache : false, 
					url: 'reqHistorian',
					dataType: 'json',
					data: JSON.stringify(obj),
					success: function(data) {
						console.log(data);
						resolve();
					},
					error: function(e){
						console.log(e);
						reject();
					}
				});
			});
		}
		
		function getFetchValues(){
			// 기간 데이터 불러오기
			return new Promise((resolve, reject)=>{
				let obj = {
					"cmd": "fetchValues",
					"param": {
						"tagList": [
							"TEST01",
							"TEST02",
							"TEST04"
						],
						"start": "2024-09-11 00:00:00", //"2024-09-11 16:12:00",
						"end": "2024-09-11 16:13:00"
					}
				};
				
				$.ajax ({
					type: 'POST',
					contentType: 'application/json; charset=utf-8',
					cache : false, 
					url: 'reqHistorian',
					dataType: 'json',
					data: JSON.stringify(obj),
					success: function(data) {
						console.log(data);
						resolve();
					},
					error: function(e){
						console.log(e);
						reject();
					}
				});
			});
		}
		
		function setHistorianValues(){
			// 히스토리안에 데이터 저장(putValues)
			return new Promise((resolve, reject)=>{
				let obj = {
					"cmd": "putValues",
					"param": {
						"tagList": [
							{
								"name": "TEST01",
								"values": [
									{
										"time": "2024-09-11 16:13:40",
										"val": "27.0",
										"type": "float"
									},
									{
										"time": "2024-09-11 16:13:50",
										"val": "27.0",
										"type": "float"
									}
								]
							},
							{
								"name": "TEST02",
								"values": [
									{
										"time": "2024-09-11 16:40:00",
										"val": "30.0",
										"type": "float"
									}
								]
							}
						]
					}
				};
				
				$.ajax ({
					type: 'POST',
					contentType: 'application/json; charset=utf-8',
					cache : false, 
					url: 'reqHistorian',
					dataType: 'json',
					data: JSON.stringify(obj),
					success: function(data) {
						console.log(data);
						resolve();
					},
					error: function(e){
						console.log(e);
						reject();
					}
				});
			});
		}
		
		function exeRvsnExecution(){
			return new Promise((resolve, reject)=>{
				// 보정 강제 실행(revisnData)
				let obj = {
						"cmd": "revisnData",
						"param": {
							"tagList": ["TEST01"],
							"start": "2024-09-11 16:13:40",
							"end": "2024-09-11 16:13:50",
							"auto": "false"
						}
					};
				
				$.ajax ({
					type: 'POST',
					contentType: 'application/json; charset=utf-8',
					cache : false, 
					url: 'reqHistorian',
					dataType: 'json',
					data: JSON.stringify(obj),
					success: function(data) {
						console.log(data);
						resolve();
					},
					error: function(e){
						console.log(e);
						reject();
					}
				});
			});
		}

*/