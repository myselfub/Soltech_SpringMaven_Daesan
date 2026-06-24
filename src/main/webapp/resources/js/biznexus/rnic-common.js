/*******************************************************************************
	*최초작성일 : 2006.06.20

	*최초작성자 : mylee
	*주요처리내용 : 폼 체크용 공통 함수
	*수정일 :
	*수정자 :
	*수정내용 :	각자 필요한 내용을 수정,등록해 사용하시면 됩니다
 ******************************************************************************/
/*
 *	global variable 선언
 */
var protocol=location.protocol;
var KEY_ENTER = 13;
var MAP_HOST_URL = protocol+"//m1.juso.go.kr";
//var HOST_URL = "www.juso.go.kr";
var HOST_URL = "business.juso.go.kr";
var url = document.location.href;
url=url.substring(0,10);
if(url == "http://eng"){
	HOST_URL = "eng.juso.go.kr";
}
var MAP_VERSION = '1,0,0,76';

var extUrl = document.location.href.replace("http://","");
var extDomain= extUrl.substring(0,extUrl.indexOf("/"));
if(extDomain == "[SERVERIP]"){
	HOST_URL = extDomain;
}

//document.domain = HOST_URL;
//document.domain = "juso.go.kr";	/*2014.12.23 */
//document.domain = "business.juso.go.kr"  /* 2022.08 */


/*
	자리수만큼 자르기
	size : 소수점이하 자리수
*/
function isAllow(code) {
	rejectCode = new Array ("'","\"","/","\\",";",":","-","+");

	for(var i=0; i<rejectCode.length; i++) {
		element = rejectCode[i];
		if(element == code){	
			alert("허용하지 않는 문자를 입력하셨습니다.");
			return false;
		}
	}
	return true;
}

function isBizArea(code, mode) {
	
	
	if(code.length < 5){
		return true;
	}
	/*else if((code == '50110' || code == '50130' || code == '44810' || code == '44230' || code == '26710' || code == '47190' || code == '47150' || code == '47170' || code == '47750' || code == '47820' || code == '47770' || code == '47130' || code == '47930' || code == '47940' || code == '47830' || code == '41273' || code == '41271' || code == '42810' || code == '44150' || code == '44760' || code == '45210' || code == '45190' || code == '43730' || code == '46170' || code == '46900' || code == '46810' || code == '46730' || code == '48270' || code == '48890' || code == '48250' || code == '43740' || code == '42770' || code == '44200' || code == '41360' || code == '48870' || code == '46870') && mode == 'search')
	{
	//	alert("이 지역은 새주소 정비사업중으로 안내정보와 현장의 건물번호가 다를 수 있으니 \n\n이용하실 때 참고 하시기 바랍니다. 불편을 드려 죄송합니다. (문의 : 해당 시군구) \n");
	}*/
	else if(code.length>5)
		code = code.substring(0,5);
		
		areaCode = new Array("42750","42780","42790","43710","44800","44825","44830","45740","45750","45770","47720","48720"); //2009년 사업지역
								
		for(var i=0; i<areaCode.length; i++) {
			element = areaCode[i];
			if(element == code){			
				return true;
			}
		}

	return false;
}

function isExceptArea(code){
	//areaCode = new Array("41280", "41190", "41130", "41110", "41270", "41170", "41460", "47110", "45110", "43110", "43130");
	areaCode = new Array("고양시", "성남시", "수원시", "안산시", "안양시", "용인시", "포항시", "전주시", "청주시","천안시","창원시","부천시");
	for(var i=0; i<areaCode.length; i++){
		element = areaCode[i];
		if(element == code){
			return true;
		}
	}
	return false;
}

function isSejong(code){
	areaCode = new Array("세종특별자치시");
	for(var i=0; i<areaCode.length; i++){
		element = areaCode[i];
		if(element == code){
			return true;
		}
	}
	return false;
}

function isEngExceptArea(code){
	//areaCode = new Array("41280", "41190", "41130", "41110", "41270", "41170", "41460", "47110", "45110", "43110", "43130");
	areaCode = new Array("Goyang-si", "Seongnam-si", "Suwon-si", "Ansan-si", "Anyang-si", "Yongin-si", "Pohang-si", "Jeonju-si", "Cheongju-si", "Cheonan-si");
	for(var i=0; i<areaCode.length; i++){
		element = areaCode[i];
		if(element == code){
			return true;
		}
	}
	return false;
}

function trunc(num,size){
	
	var str = num+'';
	var idx = str.indexOf('.');
	var positiveNum = '';
	var decimalNum = '';

	if(idx != -1){
		positiveNum = str.substring(0,idx);
		decimalNum = str.substring(idx+1,(idx+1)+size);
		
		if(decimalNum != '00')
			return positiveNum+'.'+decimalNum;
		else
			return positiveNum;
	}
	else
		return str;
}

/*
	기능 : status bar에 링크 표시 없애고 title세팅
*/
function setHideStatus()
{
    window.status="::: 보다쉽게 목적지로 안내해드립니다. - 알기쉬운 도로명주소 :::";
    return true;
}

if (document.layers)
document.captureEvents(Event.mouseover | Event.mouseout);
document.onmouseover=setHideStatus;
document.onmouseout=setHideStatus;

/*
	기능 : 입력데이터가 올바른 전화번호인지 확인 (-포함)
	----------------------------------------------
	인자 : theField 입력데이터
	반환값 : boolean
*/
function isTelNum(theField){
	 var str = theField.value;
	 var isNum = /^[0-9-]+$/;
     if( !isNum.test(str) ) {
     	  alert('전화번호를 확인해주세요!');
     	  theField.focus();
          return false; 
     }else {
		 return true;
	 }
}


/*
	기능 : 입력받은 이메일이 형식에 맞는지 확인
	--------------------------------------
	인자 : theField 입력문자열
	반환값 : boolean
*/
function isEmail(theField)
{
  var s = theField.value;
  if(s != ''){
	  if(s.search(/^\s*[\w\~\-\.]+\@[\w\~\-]+(\.[\w\~\-]+)+\s*$/g)>=0) {
		  return true;
	  }
	  else {
		  alert('이메일주소를 확인해주세요!');
		  theField.select();
		  theField.focus();
		  return false;
	  }
  }
  else
   	return true;
}

/*
문자열 trim함수
*/
function trim(strSource) {
 
	return strSource.replace(/(^\s*)|(\s*$)/g, ""); 

}

/*
All 문자치환
*/
String.prototype.replaceAll = function( searchStr, replaceStr )
{
	var temp = this;

	while( temp.indexOf( searchStr ) != -1 )
	{
		temp = temp.replace( searchStr, replaceStr );
	}

	return temp;
}

/*
널 스트링 체크  
*/
function checkStrNVMsg(form_nm,ele_nm) {

	if (trim(form_nm.value)=="") {
		alert(ele_nm+'을(를) 입력해주세요');
		form_nm.value='';
		form_nm.focus();
		return false;
	}
	return true;
}

function isCheckPW(form_nm,ele_nm) {
	
	if (trim(form_nm.value)=="") {
		alert(ele_nm+'을(를) 입력해주세요');
		form_nm.value="";
		form_nm.focus();
		return false;
	}
	if (form_nm.value.length<8)
	{
		alert("비밀번호는 8자리 이상이어야 합니다.");
		form_nm.focus();
		return false;
	}
	
	return true;
	
}

/*
	입력칸의 숫자만 입력받기
	target	: 	html object(text,textarea)
*/
function isNum(form_nm, ele_nm){
	var inText = form_nm.value;
	var ret;

		for (var i = 0; i < inText.length; i++) {
			ret = inText.charCodeAt(i);
				if (!((ret > 47) && (ret < 58))) {
					alert(ele_nm+'란에는 숫자만 입력하세요');
					form_nm.value = "";
					form_nm.focus();
					return false;
				}
		}
		return true;
}
/*
 *  상세검색 엔터 입력시 검색 추가
 */
function isNumEnter(form_nm, ele_nm, ev){
	var inText = form_nm.value;
	var ret;
	for (var i = 0; i < inText.length; i++) {
		ret = inText.charCodeAt(i);
			if (!((ret > 47) && (ret < 58))) {
				alert(ele_nm+'란에는 숫자만 입력하세요');
				form_nm.value = "";
				form_nm.focus();
				return false;
			}
	}
	var evt_code = (window.netscape) ? ev.which : ev.keyCode;
	if (evt_code == KEY_ENTER) {
		ev.KeyCode = 0;
		submitDetailSearch();
	}
	return true;
}

/*
	날짜입력받기
	target	: 	html object(text,textarea)
*/
function isDate(form_nm, ele_nm){
	var inText = form_nm.value;
	var ret;

	if(inText == "")
		return true;
		
	for (var i = 0; i < inText.length; i++) {
		ret = inText.charCodeAt(i);
			if (!((ret > 47) && (ret < 58))) {
				alert(ele_nm+'란에는 숫자만 입력하세요');
				form_nm.value = "";
				form_nm.focus();
				return false;
			}
	}

	if(inText.length != 8 ){
		
		alert('yyyymmdd 형태로 입력하세요');
		form_nm.focus();
		return false;
	}

	var yyyy	= inText.substring(0,4);
	var mm 		= inText.substring(4,6);
	var dd 		= inText.substring(6,8);

	if(yyyy < 1900){
		alert('날짜를 확인하세요');
		form_nm.focus();
		return false;
	}
	else if(mm > 12){
		
		alert('날짜를 확인하세요');
		form_nm.focus();
		return false;
	}
	else if(dd < 1){
		alert('날짜를 확인하세요');
		form_nm.focus();
		return false;
	}
	else{
	
		var endDay = new Array(31,28,31,30,31,30,31,31,30,31,30,31);
		//윤달
    	if ((yyyy % 4 == 0 && yyyy % 100 != 0) || yyyy % 400 == 0) {
        	endDay[1] = 29;
  		}

    	if(dd > endDay[mm-1]){
    		alert('날짜를 확인하세요');
			form_nm.focus();
			return false;
    	}
    	else
    		return true;
    }
}

/*
	입력칸에 숫자&영문만 입력받기
	target	: 	html object(text,textarea)
*/
function isNumOrEngChar(form_nm, ele_nm){
	var inText = form_nm.value;
	var ret;

		for (var i = 0; i < inText.length; i++) {
			ret = inText.charCodeAt(i);

				if (!((ret>47 && ret<58) || (ret>64 && ret<91) || (ret>96&&ret<123)))
				{
					alert(ele_nm+'란에는 숫자와 영문만 입력하세요');
					form_nm.value = "";
					form_nm.focus();
					return false;
				}
		}
		return true;
}

function Check_AlphaNumericSpecial(checkStr, value) {
	var checkOK = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
	var checkNUM = "0123456789";
	var result = 0;
	var resultOK = 0;
	
	for (i = 0;  i < checkStr.value.length;  i++) {
		var ch = checkStr.value.charAt(i);
		
		for (j = 0;  j < checkOK.length;  j++){
			//alert(ch+","+checkOK.charAt(j));
			if (ch == checkOK.charAt(j)){
				//alert(ch+","+checkOK.charAt(j)+"|");
				result = 1;
			}
		}
		
	}
	if (result==1)
	{
		for (k = 0;  k < checkStr.value.length;  k++) {
			var ch = checkStr.value.charAt(k);
			
			for (n = 0;  n < checkNUM.length;  n++){				
				if (ch == checkNUM.charAt(n)){
					result = 2;					
				}				
					//return true;
			}			
		}
		if (result==2)
		{
			return true;
		}
		else 
		{
			alert(value+"는 영문/숫자 혼합이여야 합니다.");
			return false;
		}
	}
	else{	
		alert(value+"는 영문/숫자 혼합이여야 합니다.");
		return false;
	}
}

function AlphaNumericSpecial(checkStr, value) {
	var checkOK = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
	var checkNUM = "0123456789";
	var result = 0;
	var resultOK = 0;
	
	for (i = 0;  i < checkStr.value.length;  i++) {
		var ch = checkStr.value.charAt(i);
		
		for (j = 0;  j < checkOK.length;  j++){
			//alert(ch+","+checkOK.charAt(j));
			if (ch == checkOK.charAt(j)){
				//alert(ch+","+checkOK.charAt(j)+"|");
				result = 1;
			}
		}
		
	}
	if (result==1)
	{
		for (k = 0;  k < checkStr.value.length;  k++) {
			var ch = checkStr.value.charAt(k);
			
			for (n = 0;  n < checkNUM.length;  n++){				
				if (ch == checkNUM.charAt(n)){
					//alert(ch+","+checkNUM.charAt(n)+"|");
					return true;
				}
					//return true;
			}
			
		}
	}
	else{	
		alert(value+"는 영문/숫자 혼합이여야 합니다.");
		return false;
	}
}

//체크박스 전체선택, 선택해제
function checkAll(formname,checkname,thestate){
	var el_collection=eval("document.forms."+formname+"."+checkname)

	if(el_collection != null)	{
		if(el_collection.length){
			for (c=0;c<el_collection.length;c++)
				el_collection[c].checked=thestate
		}
		else{
			el_collection.checked=thestate;
		}
	}
}

/**
* 입력필드의 유효성 검사를 해준다
* @param obj     : input 객체
* @param objname : 필드명 (ex) 제목
* @param astr    : 입력값의 제한을 둔다(STRING_DEF_ALPHA,STRING_DEF_NUMBER,STRING_DEF_TELDIGIT를 이용하면 편합니다)
*                  지정해 준 값만 허용하는 것이다
* @param lmin    : 최소 입력길이(byte 수)
* @param lmax    : 최대 입력길이(byte 수)
* @param showmsg : true이거나 아예 넘기지 않으면 alert를 한다
*                   false 이면 check하고 결과만 true,false로 return 한다
*/
function isString( obj , objname, astr, lmin, lmax , showmsg ){
	var i
	var t = obj.value;
	var lng = GetByteLength(obj);

	if (lng < lmin || lng > lmax) {
		if(showmsg!=null && showmsg) {
			if (lmin == lmax) alert(objname + '는 ' + lmin + ' 자 이어야 합니다');
			else alert(objname + '는 ' + lmin + ' ~ ' + lmax + ' 자 이내로 입력하셔야 합니다');
			obj.focus()
		}
		return false
	}
	if (astr.length > 1) {
		for (i=0; i < lng; i++){
			if(astr.indexOf(t.substring(i,i+1))<0) {
				if(showmsg!=null && showmsg) {
					alert(objname + '에 허용할 수 없는 문자가 입력되었습니다');
					obj.focus()
				}
				return false
			}
		}
	}
	return true
}

/**
* 스트링의 바이트 수를 센다(length를 하면 한글도 길이1로 나오는데 바이트 수는 2가 된다)
* @param obj   : textfield ,textarea objec
* @return 바이트 수
*/
function getByteLength( obj ){
	var msg = obj.value;
	var str = new String(msg);
	var len = str.length;
	var count = 0;
	for (k=0 ; k<len ; k++){
		temp = str.charAt(k);

		if (escape(temp).length > 4) {
			count += 2;
		}
		else if (temp == '\r' && str.charAt(k+1) == '\n') { // \r\n일 경우
			count += 2;
		}
		else if (temp != '\n') {
			count++;
		}
        else {
            count++;
        }
    }
	return count;	
}

/**
* 입력필드에 공백만 입력되었는지 검사를 해준다
* @param obj     : input 객체
* @param objname : 필드명 (ex) 제목
* @param showmsg : true이거나 아예 넘기지 않으면 alert를 한다
*                   false 이면 check하고 결과만 true,false로 return 한다
*/
function isBlank( obj , objname , showmsg){
	if(obj.value.replace(/ /ig,"")==""){
		if(showmsg!=null && showmsg) {
			alert(objname + "을(를) 입력하세요!");
			obj.focus();
		}
		return false;
	}
	return true;
}

/**
* 스트링의 바이트 수를 센다(length를 하면 한글도 길이1로 나오는데 바이트 수는 2가 된다)
* @param obj   : textfield ,textarea objec
* @return 바이트 수
*/
function getBytes( str ){
	var str = new String(str);
	var len = str.length;
	var count = 0;

	for (k=0 ; k<len ; k++){
		temp = str.charAt(k);
		
		if (escape(temp).length > 4) {
			count += 2;
		}
		else if (temp == '\r' && str.charAt(k+1) == '\n') { // \r\n일 경우
			count += 2;
		}
		else if (temp == '\r') { // \r일 경우
			count++;
		}
		else if (temp != '\n') {
			count++;
		} else {
			count++;
		}	
	}
	return count;	
}

/**
* 스트링을 바이트 수만큼 자른다. 물론 한글을 깨지지 않게 잘라준다(한글이 짤릴경우 버림을 취한다)
* maxlength만큼 자른 후 obj의 값을 자른 결과로 setting한다
* @param obj       : textfield ,textarea objec
* @param mexlength : 최대길이
*/
function cutBytesString( str, maxlength) {
	var len=0;
	var temp;
	var count;
	count = 0;
		
	len = str.length;

	for(k=0 ; k<len ; k++) {
		temp = str.charAt(k);

		if (escape(temp).length > 4) {
			count += 2;
		}
		else if (temp == '\r' && str.charAt(k+1) == '\n') { // \r\n일 경우
			count += 2;
		}
		else if (temp == '\r') { // \r일 경우
			count++;
		}
		else if (temp != '\n') {
			count++;
		} else {
			count++;
		}	
		if(count > maxlength) {
			str = str.substring(0,k);
			break;
		}
	}
	return str;
}

/**
* 팝업윈도우를 띄운다
* @param pop       : url
* @param winName   : 팝업 윈도우 이름
* @param width, height : 너비, 높이
* @param scroll	: scroll여부(yes/no)
* @param resize	: 마우스 드래그로 윈도우 크기 조정 가능 여부(yes/no)
*/

function popWindow(pop,winName,width,height,scroll,resize)
{
	var url = pop;  
	//var openWin;
	if (scroll == "" || scroll == null) {
		scroll = "no";
	} else{
		scroll = scroll;
	}
	if (resize == "" || resize == null) {
		resize = "no";
	} else{
		resize = resize;
	}
	openWin = window.open(url,winName,'menubar=no,scrollbars='+scroll+',resizable='+resize+',width='+width+',height='+height+',left=100,top=100');
	
	if(openWin && !openWin.closed)
	{
		openWin.focus();
	}
}	

/**
* select의 선택된 값을 리턴
* @param obj       : select객체
*/
function getSelectedValue(obj)
{
	return obj.options[obj.selectedIndex].value;

}

/**
* select의 option을 선택된 값으로 지정
* @param obj       : select객체
* @param val       : 선택시킬 option의 value
*/
function setSelectedOption(obj, val)
{

	for(i = 0 ; i < obj.options.length ; i++){
		if(obj.options[i].value == val){

			obj.options[i].selected = true;
			return;
		}
	}
}

/**
* select의 option을 선택된 값으로 지정 (name으로)
* @param obj       : select객체
* @param val       : 선택시킬 option의 value
*/
function setSelectedOptionByName(obj, val)
{

	for(i = 0 ; i < obj.options.length ; i++){
		if(obj.options[i].name == val){

			obj.options[i].selected = true;
			return;
		}
	}
}

/**
* 파일 갯수 체크
* @param form       : 입력폼객체
*/
	function checkFileCount(form, cnt){

		var w = form;
		
		if(document.all("ch_file") != null){
		
			// 기존 첨부된 파일갯수 체크
			// uncheck된 체크박스 갯수+파일인풋갯수 <= 3
			var chObj = w.ch_file;
			var chCount = chObj.length;
			var fileCount = 0 ;			// 파일 갯수
			
			// 기존파일이 한개일 경우
			if(chCount == undefined ){
				if(chObj.checked == false)
					fileCount = fileCount + 1;
			} 
			// 기존파일이 두개 이상일 경우
			else if (chCount > 1){
				for(i = 0 ; i < chCount ; i++){
					if(chObj[i].checked == false)
						fileCount = fileCount + 1;	// 기존파일갯수 합산
				}
			}
		}

		// 새로 첨부된 파일갯수 체크
		fileCount = fileCount+parseInt(w.total_file_index.value);

		if(fileCount > cnt){
			alert("파일은 "+cnt+"개까지 업로드할 수 있습니다");
			return false;
		}	
		
		return true;

	}
	

/**
* checkbox array 선택된 값이 있는지 확인
*/
		function isCheckboxChecked(obj, ele_nm)
		{ 
			var chCount = obj.length;
			
			if(chCount == undefined ){
				return true;
			} 
			else if (chCount > 1){
				for(i = 0 ; i < chCount ; i++){
					if(obj[i].checked == true)
						return true;
				}
				alert(ele_nm+'을(를) 선택해주세요!     ');
				//obj.focus();
				return false;
			}
			return true;
		} 
		
/**
* select 선택된 값이 있는지 확인
*/
		function isSelectSelected(obj, ele_nm)
		{ 
			if(getSelectedValue(obj) == ''){
				alert(ele_nm+'을(를) 선택해주세요!     ');
				obj.focus();
				return false;
			}
			return true;			
		} 
		
/**
* radio array 선택된 값이 있는지 확인
*/
		function isRadioChecked(obj, ele_nm)
		{ 
			var chCount = obj.length;
			
			if(chCount == undefined ){
				return true;
			} 
			else if (chCount > 1){
				for(i = 0 ; i < chCount ; i++){
					if(obj[i].checked == true)
						return true;
				}
				alert(ele_nm+'을(를) 선택해주세요!     ');
				return false;
			}
			return true;
		} 

/**
* 법인번호 확인
*/
function isValidCorpNum(obj){
	var temp = obj.value;
	var corpNum = '';
	if(temp.indexOf('-') != -1){
		corpNum = temp.substring(0, 6) + temp.substring(7, temp.length);
	}else{
		corpNum = obj.value;
	}
	alert('corpNum: '+corpNum);
	
    var isNum = /^[0-9-]+$/;
	if(corpNum.length != 13){
		alert('법인등록번호를 확인해주세요');
		obj.focus();
		return false;
	}
	else if(!isNum.test(str)){
		alert('법인등록번호를 확인해주세요');
		obj.focus();
		return false;
	}
	else if(Math.abs((10-(corpNum.charAt(0)*1+corpNum.charAt(1)*2+corpNum.charAt(2)*1+
                               corpNum.charAt(3)*2+corpNum.charAt(4)*1+
                               corpNum.charAt(5)*2+corpNum.charAt(6)*1+
                               corpNum.charAt(7)*2+corpNum.charAt(8)*1+
                               corpNum.charAt(9)*2+corpNum.charAt(10)*1+
                               corpNum.charAt(11)*2)%10)%10) == corpNum.charAt(12)){
		return true;
	}
	else{
		alert('법인등록번호가 유효하지 않습니다');
		obj.focus();
		return false;
	}
}

/**
 *  생년월일 확인
 */
function isBirthday(obj){
	var temp = '';
	if(temp.indexOf('-') != -1){
		temp = temp.substring(0, 4) + temp.substr(5, 2) + temp.substr(8, 2);
	}else{
		temp = obj.value;
	}
	alert('temp: '+temp);
	
	var year = Nember(temp.substr(0,4));
	var month = Nember(temp.substr(4,2));
	var day = Nember(temp.substr(6,2));
	var today = new Date();
	var yearNow = today.getFullYear();
	
	if(temp.length <= 8){
		if(1900 > year || year > yearNow){
			alert('생년월일이 유효하지 않습니다');
			obj.focus();
			return false;
		}else if(month < 1 || month > 12){
			alert('생년월일이 유효하지 않습니다');
			obj.focus();
			return false;
		}else if(day < 1 || day > 31){
			alert('생년월일이 유효하지 않습니다');
			obj.focus();
			return false;
		}else if((month == 4 || month == 6 || month == 9 || month == 11) && day == 31){
			alert('생년월일이 유효하지 않습니다');
			obj.focus();
			return false;
		}else if(month == 2){
			var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
			if(day>29 || (day==29 && !isleap)){
				alert('생년월일이 유효하지 않습니다');
				obj.focus();
				return false;
			}else{
				return true;
			}
		}else{
			return true;
		}
		
	}else{
		alert('생년월일이 유효하지 않습니다');
		obj.focus();
		return false;
	}
}

/**
* radio array 선택된 값 리턴
*/
		function getRadioChecked(obj)
		{ 
			var chCount = obj.length;

			if(chCount == undefined ){
				return null;
			} 
			else if (chCount > 1){
				for(i = 0 ; i < chCount ; i++){
					if(obj[i].checked == true)
						return obj[i].value;
				}
				return null;
			}
			return null;
		} 
		
/**
*checkbox, radiobutton disabled로 전환
*/
		function setRadioDisabled(obj, flag)
		{ 
			var chCount = obj.length;
			
			if(chCount == undefined ){
				return ;
			} 
			else if (chCount > 1){
				for(i = 0 ; i < chCount ; i++){
					obj[i].disabled = flag;
				}
			}
		} 

/**
*브라우져 내 컨트롤 활성화 
*/
function ObjectLoad(objTag)
{
	document.write(objTag);
}

function isValidSsn(obj1, obj2){
	
	var chk =0;
	
	for (var i = 0; i <=5 ; i++){
		chk = chk + ((i%8+2) * parseInt(obj1.value.substring(i,i+1)))
		}
		
		for (var i = 6; i <=11 ; i++){
		chk = chk + ((i%8+2) * parseInt(obj2.value.substring(i-6,i-5)))
		}
		
		chk = 11 - (chk %11)
		chk = chk % 10
		
		if (chk != obj2.value.substring(6,7))
		{
			alert ("주민등록번호가 유효하지 않습니다.");
			obj1.focus();
			return false;
		}
		return true;
}

/**
* 사업자번호 유효성 체크
*/
function isValidBusNum(obj1,obj2,obj3) {
	if(obj1.value+''+obj2.value+''+obj3.value != ''){
		if (obj1.value+''+obj2.value+''+obj3.value == '0000000000')
		{
			alert("사업자등록번호가 유효하지 않습니다.");
			obj1.focus(); 
			return false; 
		}

		if (BizCheck(obj1,obj2,obj3) == false) { 
			alert( "사업자등록번호가 유효하지 않습니다." ); 
			obj1.focus(); 
			return false; 
		} else { 
			return true; 
		} 
	}
	else
		return true;
}

//사업자 등록번호 체크 
function BizCheck(obj1, obj2, obj3) 
{ 
	biz_value = new Array(10); 
	
	var objstring = obj1.value +"-"+ obj2.value +"-"+ obj3.value; 
	var li_temp, li_lastid; 
	
	if ( objstring.length == 12 ) { 
	biz_value[0] = ( parseFloat(objstring.substring(0 ,1)) * 1 ) % 10; 
	biz_value[1] = ( parseFloat(objstring.substring(1 ,2)) * 3 ) % 10; 
	biz_value[2] = ( parseFloat(objstring.substring(2 ,3)) * 7 ) % 10; 
	biz_value[3] = ( parseFloat(objstring.substring(4 ,5)) * 1 ) % 10; 
	biz_value[4] = ( parseFloat(objstring.substring(5 ,6)) * 3 ) % 10; 
	biz_value[5] = ( parseFloat(objstring.substring(7 ,8)) * 7 ) % 10; 
	biz_value[6] = ( parseFloat(objstring.substring(8 ,9)) * 1 ) % 10; 
	biz_value[7] = ( parseFloat(objstring.substring(9,10)) * 3 ) % 10; 
	li_temp = parseFloat(objstring.substring(10,11)) * 5 + "0"; 
	biz_value[8] = parseFloat(li_temp.substring(0,1)) + parseFloat(li_temp.substring(1,2)); 
	biz_value[9] = parseFloat(objstring.substring(11,12)); 
	li_lastid = (10 - ( ( biz_value[0] + biz_value[1] + biz_value[2] + biz_value[3] + biz_value[4] + biz_value[5] + biz_value[6] + biz_value[7] + biz_value[8] ) % 10 ) ) % 10; 
	if (biz_value[9] != li_lastid) { 
	obj1.focus(); 
	obj1.select(); 
	return false; 
	} 
	else 
	return true; 
	} 
	else { 
	obj1.focus(); 
	obj1.select(); 
	return false; 
	} 
} 


function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function isNullPoint(obj){
	if(obj == 'null' || obj == ""){
		obj = "-";
	}
	return obj;
}

// 시도MAP 코드,레이어 매핑

function getLayerID(cd){
	
	var retValue;

	if(cd.substring(0,2) == '42')	retValue = 1;	//강원도
	if(cd.substring(0,2) == '43')	retValue = 3;	//충청북도
	if(cd.substring(0,2) == '30')	retValue = 4;	//대전
	if(cd.substring(0,2) == '11')	retValue = 2;	//서울
	if(cd.substring(0,2) == '27')	retValue = 5;	//대구
	if(cd.substring(0,2) == '31')	retValue = 6;	//울산
	if(cd.substring(0,2) == '29')	retValue = 7;	//광주
	if(cd.substring(0,2) == '41')	retValue = 8;	//경기도
	if(cd.substring(0,2) == '44')	retValue = 9;	//충남
	if(cd.substring(0,2) == '50')	retValue = 10;	//제주
	if(cd.substring(0,2) == '45')	retValue = 11;	//전북
	if(cd.substring(0,2) == '46')	retValue = 12;	//전남
	if(cd.substring(0,2) == '28')	retValue = 13;	//인천
	if(cd.substring(0,2) == '26')	retValue = 14;	//부산
	if(cd.substring(0,2) == '47')	retValue = 15;	//경북
	if(cd.substring(0,2) == '48')	retValue = 16;	//경남
	
	retValue = ( 2 + ( (retValue - 1) * 4) ) + 1;
	
	return retValue;
		
	
}

// 시도MAP 코드,레이어 매핑

function getLayerIDByEngName(engName){

	if(engName == 'busan')			return 14;
	if(engName == 'chungbuk')		return 3;
	if(engName == 'chungnam')		return 9;
	if(engName == 'daegu')			return 5;
	if(engName == 'dagjeon')		return 4;
	if(engName == 'gangwon')		return 1;
	if(engName == 'gyeonggi')		return 8;
	if(engName == 'gyeongnam')		return 16;
	if(engName == 'gyungbuk')		return 15;
	if(engName == 'incheon')		return 13;
	if(engName == 'jeju')			return 10;
	if(engName == 'jeonbuk')		return 11;
	if(engName == 'jeonnam')		return 12;
	if(engName == 'kwangju')		return 7;
	if(engName == 'seoul')			return 2;
	if(engName == 'ulsan')			return 6;
}

//맵안내 문구 쿠키이용
function setCookie(name, value) 
{ 
	var todayDate = new Date(); 
	todayDate.setDate( todayDate.getDate() + 365 ); 
	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";" 
} 

//맵안내 문구 쿠키이용
function setCookies(name, value, days) 
{ 
	var todayDate = new Date(); 
	todayDate.setDate( todayDate.getDate() + days ); 
	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";" 
} 

//쿠키 소멸 함수 
function clearCookie(name) { 
    var today = new Date() 
    //어제 날짜를 쿠키 소멸 날짜로 설정한다. 
    var expire_date = new Date(today.getTime() - 60*60*24*1000) 
    document.cookie = name + "= " + "; expires=" + expire_date.toGMTString() 
} 

function getCookieVal(name)
{
	var nameOfCookie = name + "=";
	var x = 0;
	while ( x <= document.cookie.length )
	{
			var y = (x+nameOfCookie.length);
			if ( document.cookie.substring( x, y ) == nameOfCookie ) {
					if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 )
							endOfCookie = document.cookie.length;
					return unescape( document.cookie.substring( y, endOfCookie ) );
			}
			x = document.cookie.indexOf( " ", x ) + 1;
			if ( x == 0 )
					break;
	}
	return "";
}

function setCenterLayer(name){
	var xMax = document.body.clientWidth, yMax = document.body.clientHeight;

	var xOffset = (xMax-210)/2, yOffset = (yMax-150)/2+50; 
	//중심에서 오른쪽으로 20, 아래로 40픽셀에 항상 위치하는 레이어
	
	return xOffset+"^"+yOffset;

}

var result = new Array();
var e_lon="", e_xid="";
var map_check = 0;
var m_mode ="";
var m_lon = "", m_lat="";
var m_rdMgtSn, m_xid;
var map_mode = "";

var userAgent = navigator.userAgent.toLowerCase();
var browser = {
    msie    : /msie/.test( userAgent ) && !/opera/.test( userAgent ),
    safari  : /webkit/.test( userAgent ),
    firefox : /mozilla/.test( userAgent ) && !/(compatible|webkit)/.test( userAgent ),
    opera   : /opera/.test( userAgent )
};

//지도 show/hide
function showMap()
{
	var obj = document.getElementById("viewmap");
	var obj2 = document.getElementById("mapArea");
	var obj3 = document.getElementById("mapView");
	//var obj3 = document.getElementById("map_div");
	var s_height= document.body.clientHeight - 250;
	
	if (obj2.style.display == "none")
	{
		obj2.style.visibility = "visible";
		obj2.style.display = "block";

		initMoving(obj2, s_height, 0, 0);
		//frames["viewmap"].showMap(mode);
	}
	else
	{
		if(obj.style.height == "")
		{
			obj.src = "/jsp/standardmap/MapIndex_in.jsp";
			//obj.style.height = "250px";
			//obj2.style.visibility = "visible";
			obj2.style.display = "block";
			
			initMoving(obj2, s_height, 0, 200);
			//frames["viewmap"].showMap(mode);
		}
		else
		{
			obj2.style.display = "none";
		}
	}
}

// 검색된 주소 클릭 시 이동
function moveLocation(lon, lat, lang)
{
	var obj = document.getElementById("viewmap");
	var obj2 = document.getElementById("mapArea");
	var s_height= document.body.clientHeight - 250;

	if(e_lon == lon)
	{
		if(obj2.style.display == "none")
		{
			obj2.style.display = "block";
		}
		else
			obj2.style.display = "none";
		
	}
	else
	{
		if(obj.style.height == "")
		{
			m_mode = "moveLocation";
			map_mode = "moveLocation";
			m_lon = lon;
			m_lat = lat;
			
			obj.style.height = "250px";
			obj2.style.visibility = "visible";
			
			if(lang == "kor")
				obj.src = "/jsp/standardmap/MapIndex_in.jsp";
			else
				obj.src = "/jsp/eng/standardmap/MapIndex_in.jsp";
			
			obj2.style.display = "block";
			
			initMoving(obj2, s_height, 0, 200);
			//frames["viewmap"].moveLocation(lon, lat, mode);
		}

		else
		{
			m_mode = "";
			map_mode = "moveLocation";
			obj2.style.display = "block";

			//frames["viewmap"].moveLocation(lon, lat);
			document.getElementById("viewmap").contentWindow.moveLocation(lon, lat);
		}
	}
	e_lon = lon;
	e_xid = "";
}

function moveLocation_load(rdMgtSn, xid, lang)
{
	var obj = document.getElementById("viewmap");
	var obj2 = document.getElementById("mapArea");
	var s_height= document.body.clientHeight - 250;
	
	if(e_xid == xid)
	{
		if(obj2.style.display == "none")
		{
			obj2.style.display = "block";
		}
		else
			obj2.style.display = "none";
		
	}
	else
	{
		if(obj.style.height == "" || obj2.style.display == "none")
		{
			m_mode = "moveLocation_load";
			map_mode = "moveLocation_load";
			m_rdMgtSn = rdMgtSn;
			m_xid = xid;
			
			obj.style.height = "250px";
			obj2.style.visibility = "visible";
			if(lang == "kor")
				obj.src = "/jsp/standardmap/MapIndex_in.jsp";
			else
				obj.src = "/jsp/eng/standardmap/MapIndex_in.jsp";
			obj2.style.display = "block";
			
			initMoving(obj2, s_height, 0, 200);
			//frames["viewmap"].moveLocation_load(rdMgtSn, xid, mode);
		}
		else
		{
			m_mode = "";
			map_mode = "moveLocation_load";
			obj2.style.display = "block";
			//frames["viewmap"].moveLocation_load(rdMgtSn, xid);
			document.getElementById("viewmap").contentWindow.moveLocation_load(rdMgtSn, xid);
		}
	}
	e_xid = xid;
	e_lon = "";
}

function moveLocation_load_in(rdMgtSn, xid, lang)
{
	var obj = document.getElementById("viewmap");
	var obj2 = document.getElementById("mapArea_edit");
	var s_height= document.body.clientHeight - 250;
	
	if(e_xid == xid)
	{
		if(obj2.style.display == "none")
		{
			obj2.style.display = "block";
		}
		else
			obj2.style.display = "none";
		
	}
	else
	{
		if(obj.style.height == "" || obj2.style.display == "none")
		{
			m_mode = "moveLocation_load";
			m_rdMgtSn = rdMgtSn;
			m_xid = xid;
			
			obj.style.height = "250px";
			obj2.style.visibility = "visible";
			if(lang == "kor")
				obj.src = "/jsp/standardmap/MapIndex_in.jsp";
			else
				obj.src = "/jsp/eng/standardmap/MapIndex_in.jsp";
			obj2.style.display = "block";
			
			initMoving(obj2, s_height, 0, 200);
			//frames["viewmap"].moveLocation_load(rdMgtSn, xid, mode);
		}
		else
		{
			m_mode = "";
			obj2.style.display = "block";
			//frames["viewmap"].moveLocation_load(rdMgtSn, xid);
			document.getElementById("viewmap").contentWindow.moveLocation_load(rdMgtSn, xid);
		}
	}
	e_xid = xid;
}

//건물상가 등록, 지도수정요청 지도 오픈
function openMap(x, y){

	var obj = document.getElementById("viewmap");
	var obj2 = document.getElementById("mapArea_edit");
	var s_height= document.body.clientHeight - 250;
	
	if(m_lon == x)
	{
		if(obj2.style.display == "none")
		{
			obj2.style.display = "block";
		}
		else
			obj2.style.display = "none";
	}
	else if(obj.style.height == "")
	{
		m_lon = x;
		m_lat = y;
		m_mode = "moveLocation_openMap_detail";
		
		obj.style.height = "250px";
		obj2.style.visibility = "visible";
		obj.src = "/jsp/standardmap/MapIndex_in.jsp";
		obj2.style.display = "block";
		
		initMoving(obj2, s_height, 0, 200);
	}
	else
	{
		if(obj2.style.display == "none")
		{
			m_mode = "moveLocation_openMap_detail";
			obj.src = "/jsp/standardmap/MapIndex_in.jsp";
			obj.src = "/jsp/eng/standardmap/MapIndex_in.jsp";
			obj2.style.display = "block";
			
			//frames["viewmap"].moveLocation_openMap(sggcd);
		}
		else
		{
			m_mode = "moveLocation_openMap_detail";
			obj2.style.display = "block";
			obj.src = "/jsp/standardmap/MapIndex_in.jsp";
			obj.src = "/jsp/eng/standardmap/MapIndex_in.jsp";
			
			//frames["viewmap"].moveLocation_openMap(sggcd);
		}
	}
}

function close_div()
{
	if(document.getElementById("mapArea_edit") != null && document.getElementById("mapArea_edit") != "")
		document.getElementById("mapArea_edit").style.display = "none";
	else if(document.getElementById("mapArea") != null && document.getElementById("mapArea") != "")
		document.getElementById("mapArea").style.display = "none";
}

function open_div()
{
	document.getElementById("viewmap").style.height = "250px";
	
	if(document.getElementById("mapArea_edit") != null && document.getElementById("mapArea_edit") != "")
		document.getElementById("mapArea_edit").style.visibility = "visible";
	else if(document.getElementById("mapArea") != null && document.getElementById("mapArea") != "")
		document.getElementById("mapArea").style.visibility = "visible";
	//document.getElementById(obj).style.display = "block";
	m_mode = "";
	
	remove_div("load_bar");
}

function open_div_edit()
{
	document.getElementById("viewmap").style.height = "250px";
	document.getElementById("mapArea_edit").style.visibility = "visible";
	m_mode = "";
}

function close_div_edit()
{
	document.getElementById("mapArea_edit").style.display = "none";
}

//스크롤바 이동 시 따라다니는 div
function initMoving(target, position, topLimit, btmLimit) {
	if (!target)
		return false;
	
	var obj = target;
	obj.initTop = position;
	obj.topLimit = topLimit;
	obj.bottomLimit = Math.max(document.documentElement.scrollHeight, document.body.scrollHeight) - btmLimit - obj.offsetHeight;

	obj.style.position = "absolute";
	obj.top = obj.initTop;
	obj.left = obj.initLeft;

	if (typeof(window.pageYOffset) == "number") {	//WebKit
		obj.getTop = function() {
			return window.pageYOffset;
		}
	} else if (typeof(document.documentElement.scrollTop) == "number") {
		obj.getTop = function() {
			return Math.max(document.documentElement.scrollTop, document.body.scrollTop);
		}
	} else {
		obj.getTop = function() {
			return 0;
		}
	}

	if (self.innerHeight) {	//WebKit
		obj.getHeight = function() {
			return self.innerHeight;
		}
	} else if(document.documentElement.clientHeight) {
		obj.getHeight = function() {
			return document.documentElement.clientHeight;
		}
	} else {
		obj.getHeight = function() {
			return 500;
		}
	}

	obj.move = setInterval(function() {
		if (obj.initTop > 0) {
			pos = obj.getTop() + obj.initTop;
		} else {
			pos = obj.getTop() + obj.getHeight() + obj.initTop;
			//pos = obj.getTop() + obj.getHeight() / 2 - 15;
		}

		if (pos > obj.bottomLimit)
			pos = obj.bottomLimit;
		if (pos < obj.topLimit)
			pos = obj.topLimit;

		interval = obj.top - pos;
		obj.top = obj.top - interval / 3;
		obj.style.top = obj.top + "px";
	}, 30)
}

//----------------  ajax start ------------------------------------------------------------//
var xmlHttp;
var Mode;											// ajax 요청 구분 : 행정구역조회, 건물상세정보조회, 응급의료정보조회

// 행정구역코드 세팅을 위한 input의 이름을 담은 변수
var dataFrom;	//	행저구역코드 변경 from 데이터 종류(ex: city, county. ....)
var dataTo;		//	행저구역코드 변경 to 데이터 종류(ex: county, rd_nm, town ....)
var objFrom;	//	실제로 onchange가 일어나는 input이름(ex: city1, county1, city2, county2, ....)
var objTo;		//	실제로 행정구역코드 리스트를 달아줄 input 이름(ex: county1, rd_nm1, county2, ...)
var objClear;					
var areaIdx;	//	1:통합검색, 2:최단거리검색, 3:생활정보검색, 4:응급의료검색
var bldnm,group_nm,oldaddr_nm,newaddr_nm,livein_cnt,corplist;	// 건물상세정보 세팅을 위한 input들의 이름을 담은 변수

/*
 * MSXML 버전 체크
 */
 function xmlVersionCheck(){
	
	var version =["Msxml2.XMLHTTP.6.0","Msxml2.XMLHTTP.3.0","Microsoft.XMLHTTP"];
	for(var data in version){
		try{
			var xmlDom = new ActiveXObject(version[data]);
			return xmlDom;
		}catch(ex){alert("xmlVersionCheck error")}
	}
	return null;
}
 
/*
 *	브라우저 종류에 따른 Request객체 생성
 */
function createXMLHttpRequest() {

  if(xmlHttp != null) {
  	xmlHttp.abort();
  	delete xmlHttp;
  	xmlHttp = null;
  }
  	
  if (window.ActiveXObject) {
       //xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
	  xmlHttp = xmlVersionCheck();
  } 
  else if (window.XMLHttpRequest) {
       xmlHttp = new XMLHttpRequest();
  }
}
/*
 *	브라우저 종류에 따른 Request객체 가져오기
 */
function getXMLHttpRequest() {
	if (window.ActiveXObject) {
		var msxml = xmlVersionCheck();
		return msxml;
	} else if (window.XMLHttpRequest) {
		return new XMLHttpRequest();
	} else {
		return null;
	}
}

/*
		행정구역코드 select 정리
		1) 통합검색
				-공통 			: city1, county1
				-도로명주소검색 	: rd_nm_idx1, rd_nm1
				-지번주소검색 	: town1_oldaddr
				-건물명검색 	: town1_bldnm
				-전화번호검색 	: town1_telnum
		2) 최단거리검색
				- 출발지검색 	: city2_start, county2_start
				- 도착지검색 	: city2_desti, county2_desti
				- 경유지검색 	: city2_bypass, county2_bypass
		3) 생활정보검색
				- city3, county3
		4) 응급의료검색
				- city4, county4
*/


/*
 *	ajax사용 1 - 행정구역코드 리스트 변경(mode : area)
 *
 *	param : this object
 */
function changeAreaList(idx, obj){

	if(obj.id == '' || obj.id == 'undefined')
	return;
	
	areaIdx = idx;
	Mode 	= 'area';
	var searchType = document.getElementById("searchType").value;

	dataFrom, dataTo, objFrom, objTo, objClear;   		
	
	// 지도검색 
	if(obj.id == 'city1'){
		dataFrom 	= 'city';
		dataTo 		= 'county';
		objFrom		= 'city1';
		objTo		= 'county1';
		objClear	= 'town1_bldnm';
		objFrom		= 'city1';
		objTo		= 'county1';
	}
	else if(obj.id == 'city2'){
		dataFrom 	= 'city';
		dataTo 		= 'county';
		objFrom		= 'city2';
		objTo		= 'county2';
		objClear	= 'town1_oldaddr';
		objFrom		= 'city2';
		objTo		= 'county2';
	}
	else if(obj.id == 'city3'){
		dataFrom 	= 'city';
		dataTo 		= 'county';
		objFrom		= 'city3';
		objTo		= 'county3';
		objClear	= 'rd_nm3';
		objFrom		= 'city3';
		objTo		= 'county3';
	}
	// 지도검색 
	else if(obj.id == 'county1'){
		dataFrom 	= 'county';
		objClear	= '';
		dataTo 		= 'town';
		objTo		= 'town1_bldnm';
		objFrom		= 'county1';
	}
	else if(obj.id == 'county2'){
		dataFrom 	= 'county';
		objClear	= '';
		dataTo 		= 'town';
		objTo		= 'town1_oldaddr';
		objFrom		= 'county2';
	}
	else if(obj.id == 'county3'){
		dataFrom 	= 'county';
		objClear	= '';
		dataTo 		= 'rd_nm';
		objTo		= 'rd_nm3';
		objFrom		= 'county3';
	}
	else if(obj.id == 'town1_oldaddr'){
		dataFrom 	= 'town';
		objFrom		= 'town1_oldaddr';
		objClear	= '';
		dataTo 		= 'ri';
		objTo		= 'ri1_oldaddr';
	}
	// 지도검색 
	else if(obj.id == 'rd_nm_idx3'){
		dataFrom 	= 'county';
		objFrom		= 'county3';
		objClear	= '';
		
		if(searchType == 'NORMAL3'){		//	도로명 검색
			dataTo 		= 'rd_nm';
			objTo		= 'rd_nm3';
		}
	}

	// 생활정보검색 1
	else if(obj.id == 'city4'){		
	
		dataFrom 	= 'city';
		dataTo 		= 'county';
		objFrom		= 'city4';
		objTo		= 'county4';
		objClear	= '';
	}
	
	//	update해야 할 select를 초기화
	clearList(objTo);
	objcounty3 = document.getElementById("county3");
	//alert(dataTo + " : " + objcounty1.options[objcounty1.selectedIndex].text + " : " + obj.id);
	if(dataTo == 'rd_nm' && objcounty3.options[objcounty3.selectedIndex].text != "::선택::" && obj.id == 'county3' || obj.id == 'rd_nm_idx3')
	{
		document.getElementById("rd_nm3").options[0] = new Option("검색중...","검색중...");
	}
	//	clear해야 할 select가 설정된 경우 초기화
	if(objClear != ''){
		// 도로명 clear인 경우, 도로명 인덱스 선택 초기화
		if(objClear.indexOf("rd_nm") != -1){
			var rdIdxName = 'rd_nm_idx'+areaIdx;
			document.getElementById(rdIdxName).options[0].selected = true;
		}
	 	clearList(objClear);
	}
	
	// from object 선택값이 없으면 return
	if(document.getElementById(objFrom).value == ''){
		return;
	}

	var url = "/getAreaCode.do";// + createParameter() ;
	var params = createParameter();
//alert(searchType+'>>>'+url+'>>>'+objTo);

  	createXMLHttpRequest();

	xmlHttp.open("POST", url, true);	 	
	xmlHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=UTF-8");
	//xmlHttp.setRequestHeader("Content-length", params.length);
	//xmlHttp.setRequestHeader("Connection", "close");
 	xmlHttp.onreadystatechange = handleStateChange;
	
 	xmlHttp.send(params);
}
/*
 *	ajax사용 2 - 건물상세정보 표시(통합검색, 생활정보검색 탭에서 사용)(mode : building)
 *	gubun 	: normal(통합검색), living(생활정보검색)
 */
function changeBldInfo(gubun, id){

	var url = "/standardmap/getBldInfo.do?BdMgrSn=";
	if(gubun=='AddrDongDetail')
	{
		 Mode = 'AddrDongDetail';
		 gubun='normal';
		 url = "/standardmap/getBldInfo.do?Detail=1&BdMgrSn=";
	}else
	{
	 Mode = 'building';
	}
	bldnm 		= 'bldnm_'+gubun;

	group_nm	= 'group_nm_'+gubun;
	oldaddr_nm  = 'oldaddr_nm_'+gubun;
	newaddr_nm	= 'newaddr_nm_'+gubun;
	livein_cnt	= 'livein_cnt_'+gubun;
	//corplist	= 'corplist_'+gubun;

	clearBldInfo();

	url = url + id ;
	
	//alert(url);
  	createXMLHttpRequest();
 	xmlHttp.onreadystatechange = handleStateChange;
  	xmlHttp.open("GET", url, true);
  	xmlHttp.send(null);
}

/*
 *	건물상세정보란 clear
 */
function clearBldInfo(){
	//alert(bldnm + " " + group_nm + " " + newaddr_nm + " " + oldaddr_nm + " " + livein_cnt);

   document.getElementById(bldnm).innerHTML = '';
   document.getElementById(group_nm).innerHTML = '';
   document.getElementById(newaddr_nm).innerHTML = '';
   document.getElementById(oldaddr_nm).innerHTML = '';
   //document.getElementById(livein_cnt).value = '';
   /*
	var selCorpObj = document.getElementById(corplist);

  	while(selCorpObj.childNodes.length > 0) {
       selCorpObj.removeChild(selCorpObj.childNodes[0]);
  	}
  	*/
}

/*
 *	ajax사용 3 - 응급의료 상세정보 표시
 */
function getEmergencyDetail(hospitalMgtSn){

	Mode = 'emergency';

	clearEmergencyDetail();

	var url = "/gismap/getEmergencyDetail.do?hospitalMgtSn=" + hospitalMgtSn ;

  	createXMLHttpRequest();
 	xmlHttp.onreadystatechange = handleStateChange;
  	xmlHttp.open("GET", url, true);
  	xmlHttp.send(null);
}
       
/*
 *	응급의료상세정보란 clear    
 */
function clearEmergencyDetail(){

	document.getElementById('hospital_nm').innerText='';
	document.getElementById('hospital_kind').innerText='';
	document.getElementById('medical_tp').innerText='';
	document.getElementById('tel_cn').innerText='';
	document.getElementById('hour_cn').innerText='';
	//document.getElementById('addr').value='';
}

/*
 *	행정구역 조회 쿼리에 사용할 파라메터값 설정
 */
function createParameter() {
	
	var rdIndex;
	
	// 도로명 clear인 경우, 도로명 인덱스 선택 초기화
	if(dataTo.indexOf("rd_nm") != -1){
		var rdIdxName = 'rd_nm_idx'+areaIdx;
		rdIndex = document.getElementById(rdIdxName).value;
	}
	
	var valFrom		= document.getElementById(objFrom).value;
	var valTo		= document.getElementById(objTo).value;
	
	//	시군구>도로명, 시군구>지번주소인 경우
	//	시도코드도 가져가야함
	if(dataFrom == 'county'){
		var cityName = 'city'+areaIdx;
		var cityVal = document.getElementById(cityName).value;
		
		valFrom = cityVal+valFrom;
	}else if(dataFrom == 'town'){
		var cityName	= 'city'+areaIdx;
		var countyName	= 'county'+areaIdx;
		
		valFrom = document.getElementById(cityName).value+document.getElementById(countyName).value+valFrom
	}

	var queryString = "from="+dataFrom+"&to="+dataTo+"&valFrom="+valFrom+"&valTo="+valTo+"&rdIndex="+rdIndex;
	//alert(queryString);
  	return queryString;
}

function uriEncode(data) 
{
    if(data != "") 
    {
        var encdata = '';
        var datas = data.split('&');
        
        for(i=1;i<datas.length;i++) 
        {
            var dataq = datas[i].split('=');
            encdata += '&'+encodeURIComponent(dataq[0])+'='+encodeURIComponent(dataq[1]);
        }
    } 
    else 
    {
        encdata = "";
    }
 return encdata;
}

/*
 *	응답을 받아 리스트를 update
 */
function handleStateChange() {
//alert(xmlHttp.readyState + " : " + xmlHttp.status);
  if(xmlHttp.readyState == 4) {
       if(xmlHttp.status == 200) {
    	   if(Mode == 'area')				// 	행정구역코드조회
          		updateAreaList();
          	else if(Mode == 'building')		//	건물상세정보조회
          	{
          		updateBldInfo();
          	}
          	else if(Mode == 'road')		//	건물상세정보조회
          	{
          		updateRoadInfo();
          	}
          	else if(Mode == 'areainfo')
          	{
          		updateAreaInfoPopup();
          	}
          	else if(Mode == 'buildinginfo')
          	{
          		updateBldInfoPopup();
          	}
          	else if(Mode == 'roadinfo')
          	{
          		updateRoadInfoPopup();
          	}
           	delete xmlHttp;
           	xmlHttp = null;
       }
  }
}
/*
 *	건물정보 update
 */
function updateBldInfo() {

  //var selObj 	= document.getElementById(corplist);
  var bldNm 	= xmlHttp.responseXML.getElementsByTagName('bldnm');
  var groupNm	= xmlHttp.responseXML.getElementsByTagName('group_nm');
  var newAddr 	= xmlHttp.responseXML.getElementsByTagName('newaddr');	  
  var oldAddr 	= xmlHttp.responseXML.getElementsByTagName('oldaddr');
  //var liveinVals = xmlHttp.responseXML.getElementsByTagName('livein_info');	  
  //var liveinValLen = liveinVals.length; 
  
   document.getElementById(bldnm).innerHTML = bldNm[0].firstChild.nodeValue;
   document.getElementById(group_nm).innerHTML = groupNm[0].firstChild.nodeValue;
   document.getElementById(newaddr_nm).innerHTML = newAddr[0].firstChild.nodeValue;	   
   document.getElementById(oldaddr_nm).innerHTML = oldAddr[0].firstChild.nodeValue;	
   //document.getElementById(livein_cnt).value = liveinValLen;
   
   //top.document.getElementById("encoding").document.getElementById("new_addr").value = newAddr[0].firstChild.nodeValue;
   //top.upLoad.document.getElementById("new_addr").value = newAddr[0].firsttop.nodeValue;
   //top.upLoad.document.getElementById("old_addr").value = oldAddr[0].firstChild.nodeValue;
   
   //인쇄시 도로명주소, 지번 주소를 표현
   top.pop_print_info = "[도로명주소] " + newAddr[0].firstChild.nodeValue + "<br>";
   top.pop_print_info += "[지번주소] " + oldAddr[0].firstChild.nodeValue;
   /*
   var empty = new Array();
   
   // 선택 표시 option 생성
  if(liveinValLen>0){
  	var option = new Option('::선택하세요::', '');
  	selObj.options[0]= option;
  }
  else{
  	var option = new Option('::입주 업체정보가 없습니다::', '');
  	selObj.options[0]= option;
  }
   //  리스트 수만큼 option을 달아준다
  for(var i = 0; i < liveinValLen; i++) 
  {
  		try{empty[i] = liveinVals[i].childNodes[0].firstChild.nodeValue;}catch(e){empty[i] = "업체명칭 없음";}
		var option = new Option(empty[i], liveinVals[i].childNodes[1].firstChild.nodeValue);
       	selObj.options[i+1]= option;
  }*/
}

/*
 *	행정구역코드 리스트를 update
 */
function updateAreaList() {

  var toObj 	= document.getElementById(objTo);
  var values 	= xmlHttp.responseXML.getElementsByTagName('value');
  var names 	= xmlHttp.responseXML.getElementsByTagName('name');
  var j = 1;
  
  // 셀렉트 박스 초기화
  clearList(objTo);
  
  //  리스트 수만큼 option을 달아준다
  for(var i = 0; i < values.length; i++) {
		
		if(isExceptArea(names[i].firstChild.nodeValue)){
			//alert(names[i].firstChild.nodeValue);
			j = j - 1;
		}
		else{
			var option = new Option(names[i].firstChild.nodeValue, values[i].firstChild.nodeValue);
			option.title = names[i].firstChild.nodeValue;
			
       		toObj.options[i+j] = option;
       		//alert("포함:"+values[i].firstChild.nodeValue);
       	}
   }

}

function updateBldInfoPopup() {
	//alert(' set bld info...'+bldNm[0].firstChild.nodeValue);
		  
  //document.getElementById("map_info").style.height = "160px";
	
  var bldNm 	= xmlHttp.responseXML.getElementsByTagName('bldnm');
  //var groupNm	= xmlHttp.responseXML.getElementsByTagName('group_nm');
  var newAddr 	= xmlHttp.responseXML.getElementsByTagName('newaddr');	  
  var oldAddr 	= xmlHttp.responseXML.getElementsByTagName('oldaddr');
  var bdMgtSn 	= xmlHttp.responseXML.getElementsByTagName('bdMgtSn');
  
  //Map_info.document.getElementById("road").style.visibility = "hidden";
  //Map_info.document.getElementById("area").style.visibility = "hidden";
  //Map_info.document.getElementById("grantde").style.visibility = "hidden";
  //Map_info.document.getElementById("building").style.visibility = "visible";
   		
   //Map_info.document.getElementById("bldnm").value = isNullPoint(bldNm[0].firstChild.nodeValue);
   //info.document.getElementById("group_nm").value = groupNm[0].firstChild.nodeValue;
   var newaddr_nm = isNullPoint(newAddr[0].firstChild.nodeValue);
   var oldaddr_nm = isNullPoint(oldAddr[0].firstChild.nodeValue);	 	   
   //ResizeFrom(newaddr_nm, "newaddr_nm");
   //ResizeFrom(oldaddr_nm, "oldaddr_nm");
   //Map_info.document.getElementById("newaddr_nm").innerHTML = newaddr_nm;   //상세정보 도로명주소
   //Map_info.document.getElementById("oldaddr_nm").innerHTML = oldaddr_nm;	//상세정보 지번
   //upLoad.document.getElementById("new_addr").value = newAddr[0].firstChild.nodeValue;	//인쇄시 도로명주소 표시를 위한
   //upLoad.document.getElementById("old_addr").value = oldAddr[0].firstChild.nodeValue;	//인쇄시 지번 표시를 위한
   //인쇄시 도로명주소, 지번 주소를 표현
   pop_print_info = "[도로명주소] " + newAddr[0].firstChild.nodeValue + "<br>";
   pop_print_info += "[지번주소] " + oldAddr[0].firstChild.nodeValue;
   //info.document.getElementById(livein_cnt).value = liveinValLen;
   var value = isNullPoint(bldNm[0].firstChild.nodeValue) + "^" + newaddr_nm + "^" + oldaddr_nm;
   //alert(value);
   // Oepnlayers로 팝업 속성 전달
   //frames["viewmap"].popupinfo("building", value);
   document.getElementById("viewmap").contentWindow.popupinfo("building", value);
   
   //layerOnOff();
}

function updateRoadInfoPopup()
{
	//document.getElementById("map_info").style.height = "225px";
	
	var roadnm 	= xmlHttp.responseXML.getElementsByTagName('roadname');	
  	var startroad 	= xmlHttp.responseXML.getElementsByTagName('start_road');	  
  	var endroad 	= xmlHttp.responseXML.getElementsByTagName('end_road');
  	var grantderoad 	= xmlHttp.responseXML.getElementsByTagName('grantde_road');
  	
  	//Map_info.document.getElementById("road").style.visibility = "visible";
  	//Map_info.document.getElementById("area").style.visibility = "hidden";
   	//Map_info.document.getElementById("building").style.visibility = "hidden";
   	//Map_info.document.getElementById("grantde").style.visibility = "hidden";
   	
  	//Map_info.document.getElementById("road_nm").value = isNullPoint(roadnm[0].firstChild.nodeValue);
  	//Map_info.document.getElementById("start_road").value = isNullPoint(startroad[0].firstChild.nodeValue);
  	//Map_info.document.getElementById("end_road").value = isNullPoint(endroad[0].firstChild.nodeValue);
  	//Map_info.document.getElementById("grantde_road").value = isNullPoint(grantderoad[0].firstChild.nodeValue);

  	var value =  isNullPoint(roadnm[0].firstChild.nodeValue) + "^" + isNullPoint(startroad[0].firstChild.nodeValue)+ "^" + isNullPoint(endroad[0].firstChild.nodeValue) + "^" + isNullPoint(grantderoad[0].firstChild.nodeValue);
  	//alert(value);
    // Oepnlayers로 팝업 속성 전달
    //frames["viewmap"].popupinfo("road", value);
  	document.getElementById("viewmap").contentWindow.popupinfo("road", value);
  	
	//layerOnOff();
}
function updateAreaInfoPopup()
{
	//document.getElementById("map_info").style.height = "160px";

	var areaNm	= xmlHttp.responseXML.getElementsByTagName('areaname');
	
	//Map_info.document.getElementById("building").style.visibility = "hidden";  //div name
	//Map_info.document.getElementById("road").style.visibility = "hidden";
	//Map_info.document.getElementById("grantde").style.visibility = "hidden";
	//Map_info.document.getElementById("area").style.visibility = "visible";

	//Map_info.document.getElementById("area_nm").value = isNullPoint(areaNm[0].firstChild.nodeValue);

	var value =  isNullPoint(areaNm[0].firstChild.nodeValue);
	
	//frames["viewmap"].popupinfo("area", value);
	document.getElementById("viewmap").contentWindow.popupinfo("area", value);
	
}
/*
 *	행정구역코드 모든 리스트를 초기화
 */
function clearAllList() {

  	var countyObj = document.getElementById(vCounty);
  
  	countyObj.options.length = 0;
	countyObj.options[0] = new Option('::선택::', '');
   
   	clearList(to);
}

/*
 *	지정된 행정구역코드 리스트를 초기화
 */
function clearList(obj) {
	if(obj == 'town1_oldaddr'){
		var toObject = document.getElementById(obj);
		  
		toObject.options.length = 0;
		toObject.options[0] = new Option('::선택::', '');
		$("#"+obj).parent().find(".select-title strong").text("::선택::");
		document.getElementById("ri1_oldaddr").options.length = 0;
		document.getElementById("ri1_oldaddr").options[0] = new Option('::선택::', '');
	}
	else if(obj != '' && obj != 'town1_oldaddr'){
		
		var toObject = document.getElementById(obj);
		toObject.options.length = 0;
		toObject.options[0] = new Option('::선택::', '');
		$("#"+obj).parent().find(".select-title strong").text("::선택::");
	}
}
	

//----------------  ajax end ------------------------------------------------------------//

// 업체 상세정보 팝업 띄우기
function openDetailInfo(obj)
{
	var w = document.check;
	var bus = document.getElementById(corplist).value;

	if(bus != ''){
		
		var newAddr = document.getElementById(newaddr_nm).innerHTML;
		var oldAddr = document.getElementById(oldaddr_nm).innerHTML;
		var bldNm 	= document.getElementById(bldnm).innerHTML;
		
		var url = "/gismap/BusinessInfo.do?bdMgtSnNCoCd="+bus+"&newAddr="+newAddr+"&oldAddr="+oldAddr+"&bldNm="+bldNm;
		var winName = "업체상세정보";
		var width = 420;
		var height = 420;
		var scroll = "yes";
		var resize = "no";
		
		popWindow(url,winName,width,height,scroll,resize);
	}
}

function chkAjaBrowser()
{
  var a,ua = navigator.userAgent;
  this.bw= { 
       safari    : ((a=ua.split('AppleWebKit/')[1])?a.split('(')[0]:0)>=124 ,
      konqueror : ((a=ua.split('Konqueror/')[1])?a.split(';')[0]:0)>=3.3 ,
      mozes     : ((a=ua.split('Gecko/')[1])?a.split(" ")[0]:0) >= 20011128 ,
      opera     : (!!window.opera) && ((typeof XMLHttpRequest)=='function') ,
     msie      : (!!window.ActiveXObject)?(!!createHttpRequest()):false 
  }
  return (this.bw.safari||this.bw.konqueror||this.bw.mozes||this.bw.opera||this.bw.msie);
}

/*
 *	통합검색 key down function (엔터키가 입력되면 검색함수 호출)
 */
function checkKeyAndSubmitNormalSearch(e)
{
	if(e.keyCode == 13)
	{
		normalSearch();
	}
}

/*
 *	간편검색 key down function (엔터키가 입력되면 검색함수 호출)
 */
function checkKeyAndSubmitSimpleSearch(e)
{
	if(e.keyCode == 13) 
	{
		addressMapSerarch();
	}
}
// div 생성
function creatediv(div_id, div_left, div_right, div_top, div_width, div_height, div_zindex, strHTML)
{
	var div = document.createElement("div");

	if(document.getElementById(div_id))
		return;
	
	div.setAttribute('id', div_id);
	if(div_left != 0)
	{
		div.style.left = div_left+"px";
	}
	if(div_right != 0)
	{
		div.style.right = div_right+"px";	
	}
	div.style.top = div_top+"px";
	div.style.width = div_width+"px"; 
	div.style.height = div_height+"px";
	div.style.z_index = div_zindex;
	div.style.position = "absolute";
	div.style.display = "block";
	div.innerHTML = strHTML;

	//div.style.overflow = "auto";
	//div.style.background
	//div.style.border
	if(document.getElementById("wrap")!=null) {
		document.getElementById("wrap").appendChild(div);
	} else {
		document.body.appendChild(div);
	}
}
// div 삭제
function removediv(div_id)
{
	if(document.getElementById("wrap")!=null) {
		document.getElementById("wrap").removeChild(document.getElementById(div_id));
	} else{
		document.body.removeChild(document.getElementById(div_id));
	}
}

//	리스트 결과 클릭 후 지도의 해당 위치 선택
function moveAndSelectLocation(id, noD, noK)
{	
	centerX = noD;// tmp[0];
	centerY = noK;// tmp[1];
	
	//frames["viewmap"].ZoomCenter(centerX,centerY);
	document.getElementById("viewmap").contentWindow.ZoomCenter(centerX,centerY);
}
// 맵서비스에서 상세주소 클릭 시 지도의 해당위치 이동
function moveAndSelectLocationMap(noD, noK, entD, entK, eqbManSn, bdMgtSn, rdMgtSn)
{	
	document.getElementById("viewmap").contentWindow.setBuldCenterXY(noD, noK, entD, entK);
	
	if (eqbManSn != 0) {
		//var sigCd = bdMgtSn.substring(0,5);
		//var sigCd = rnMgtSn.substring(0,5);
		document.getElementById("viewmap").contentWindow.ZoomCenterMapEnt(noD, noK, entD, entK);
		document.getElementById("viewmap").contentWindow.doGetBasPoly(rdMgtSn, eqbManSn);
	} else {
		document.getElementById("viewmap").contentWindow.ZoomCenterMap(noD, noK);
		document.getElementById("viewmap").contentWindow.doGetBasPoly(rdMgtSn, bdMgtSn, "ENTRC");
	}
	
}
// 맵서비스에서 상세주소 클릭 시 지도의 해당위치 이동
function moveAndSelectLocationMapMini(noD, noK, entD, entK, eqbManSn, bdMgtSn, rdMgtSn)
{	
	
	document.getElementById("viewmap").contentWindow.setBuldCenterXY(noD, noK, entD, entK);
	if (eqbManSn != 0) {
		//var sigCd = bdMgtSn.substring(0,5);
		//var sigCd = rnMgtSn.substring(0,5);
		document.getElementById("viewmap").contentWindow.doGetBasPoly(rdMgtSn, eqbManSn);
		document.getElementById("viewmap").contentWindow.ZoomCenterMapEnt(noD, noK, entD, entK);
	} else {
		document.getElementById("viewmap").contentWindow.doGetBasPoly(rdMgtSn, bdMgtSn, "ENTRC");
		document.getElementById("viewmap").contentWindow.ZoomCenterMap(noD, noK);
	}
	
}
function zoomlevel(level)
{
	//frames["viewmap"].map_zoomlevel(level);
	document.getElementById("viewmap").contentWindow.map_zoomlevel(level);
}

function decrypt(x,y)
{
	var centerX = x / 0.3 - 333333;
	var centerY = y / 0.3 - 333333;
	
	return [centerX, centerY];
}

function encrypt(x,y)
{
	var centerX = (x + 333333) * 0.3;
	var centerY = (y + 333333) * 0.3;
	
	return [centerX, centerY];
}

function create_div(div_id)
{
	var strHTML = "";

	if(div_id == "load_bar")
	{
//		strHTML += '<html>';
//		strHTML += '<body topmargin="0" leftmargin="0" marginheight="0" marginwidth="0" >';
		strHTML += '<img src="/img/map/loading.gif" border="0" title="로딩중입니다" alt="로딩중입니다">';
//		strHTML += '</body>';
//		strHTML += '</html>';

		
		creatediv(div_id, 525, 0, 390, 40, 220, 5, strHTML);
	}
}

function map_control(control)
{
	if(control == "appini")
	{
		//frames["viewmap"].appini();
		document.getElementById("viewmap").contentWindow.appini();
	}
	else if(control == "appdist")
	{
		//frames["viewmap"].appdist();
		document.getElementById("viewmap").contentWindow.appdist();
	}
	else if(control == "apparea")
	{
		//frames["viewmap"].apparea();
		document.getElementById("viewmap").contentWindow.apparea();
	}
	else if(control == "Show3D")
	{
		//frames["viewmap"].Show3D();
		document.getElementById("viewmap").contentWindow.Show3D();
	}
	else if(control == "appPrint")
	{
		//frames["viewmap"].appPrint(pop_print, pop_print_info);
		document.getElementById("viewmap").contentWindow.appPrint(pop_print, pop_print_info);
	}
	else if(control == "showInfo")
	{
		g_mapModify = false;
		//var scale = frames["viewmap"].getMapScale();
		var scale = document.getElementById("viewmap").contentWindow.getMapScale();

		if (scale > 2500)
		{
			alert('위치를 선택하시려면 지도 스케일을 좀더 확대하여 주십시오.');
			return;
		}
		else
		{
			alert("지도상에서 위치를 선택하시기 바랍니다.");
			//frames["viewmap"].showInfo();
			document.getElementById("viewmap").contentWindow.showInfo();
		}
	}
	else if(control == "roadInfo")
	{
		if(test == 0)
		{
			//frames["viewmap"].roadInfo(7,4,1);
			document.getElementById("viewmap").contentWindow.roadInfo(7,4,1);
			test = 1;
		}
		else
		{
			//frames["viewmap"].roadInfo(7,4,0);
			document.getElementById("viewmap").contentWindow.roadInfo(7,4,0);
			test = 0;
		}
	}
	else if(control == "appzin")
	{
		//frames["viewmap"].appzin();
		document.getElementById("viewmap").contentWindow.appzin();
	}
	else if(control == "appzout")
	{
		//frames["viewmap"].appzout();
		document.getElementById("viewmap").contentWindow.appzout();
	}
	else if(control == "appmove")
	{
		document.getElementById("viewmap").contentWindow.appmove();
	}
	else if(control == "appfull")
	{
		document.getElementById("viewmap").contentWindow.appfull();
	}
	else if(control == "appBack")
	{
		document.getElementById("viewmap").contentWindow.appBack();
	}
	else if(control == "appForward")
	{
		document.getElementById("viewmap").contentWindow.appForward();
	}
	else if(control == "appSaveMap")
	{
		//document.getElementById("viewmap").contentWindow.appSaveMap();
		document.getElementById("viewmap").contentWindow.appSaveMap(pop_print, pop_print_info);
	}
	else if(control == "guidebookMap")
	{
		document.getElementById("viewmap").contentWindow.guidebookMap();
	}
}


function openMapBrowser(){
	var agt=navigator.userAgent.toLowerCase();

    if(agt.indexOf("msie") == -1)
    {
            var query = location.href.substring((location.href.indexOf('#')+1), location.href.length);
            var querysplit = query.split('?');
            var param = "";

            if(querysplit[1] != undefined)
            {
                    param = "?" + querysplit[1];
            }
            window.open('/gismap-new/MapIndex.do', 'MapBrowser', 'scrollbars=no, status=yes, resizable=yes, width=980, height=690');
    }else{
		window.open('/gismap-new/MapIndex.htm', 'MapBrowser', 'scrollbars=no, status=yes, resizable=yes, width=980, height=690');
    }
}

function openMapSearchHelp(){
	window.open('/support/MapSearchHelp.htm', 'popName', 'width=600,height=600');

}

function openGuide(){
	if(confirm("새창을 여시겠습니까?")){
		window.open('/help/Guide.htm', 'popName', 'width=925,height=650'); return false;
	}
}

function openPrivacy(){
	if(confirm("새창을 여시겠습니까?")){
		window.open('/common/policy_process.htm', 'popName', 'width=730,height=500');return false;
	}
}

function openNewMapBrowser(){
	var sWidth = screen.availWidth;
	var sHeight = screen.availHeight;
	window.open(MAP_HOST_URL + '/gismap-new/MapIndex.do', '지도서비스', 'width='+sWidth+',height='+sHeight+',left=0,top=0, menubar=no,status=no,directiories=no');

}
function openEngMapBrowser(){
	var sWidth = screen.availWidth;
	var sHeight = screen.availHeight;
	window.open(MAP_HOST_URL + '/eng/standardmap/MapIndex.do', 'map', 'width='+sWidth+',height='+sHeight+',left=0,top=0, menubar=no,status=yes,resizable=yes,directiories=no');

}
/*상세검색추가*/
function showDetailSearchDiv(gubun){
	if(gubun==1)
	{
	    document.getElementById("detailSearchDivId").style.display="block";
	}else
	{
		document.getElementById("detailSearchDivId").style.display="none";
	}
}

var d_areaIdx, d_dataFrom, d_dataTo, d_objFrom, d_objTo, d_objClear; 

function changeAreaList1(idx, obj){

	if(obj.id == '' || obj.id == 'undefined')
	return;

	var type = radioValue(document.getElementById("AKCFrm").dssearchType1);

	
	d_areaIdx = idx;
	/* d_areaIdx
	 * 1.  도로명
	 * 
	 * 
	 */
	if(obj.id == 'dscity1'){
	// 통합검색 

		d_dataFrom 	= 'city';
		d_dataTo 		= 'county';
		d_objFrom		= 'dscity1';
		d_objTo		= 'dscounty1';
		//objClear	= '';
		
		if(type == "road")
		{
			d_objClear	= 'dsrd_nm1';
		}else if(type == "jibun")
		{
			clearList1('dsri1');
			d_objClear	= 'dstown1';
		}else if(type == "building")
		{
			d_objClear	= 'dstown2';
		}

		document.getElementById("dscounty1").disabled = false;
		if(document.getElementById(obj.id).value =='36'){
			document.getElementById("dscounty1").disabled = true;
		//	document.getElementById("county1").value="36110";
			d_dataFrom 	= 'county';
			d_objFrom		= 'dscounty1';
			d_objClear	= 'dscounty1';


			if(type == "road")
			{
				d_objTo = 'dsrd_nm1';
				d_dataTo = 'rd_nm';
			}else if(type == "jibun")
			{
				clearList1('dsri1');
				d_objTo = 'dstown1';
				d_dataTo = 'town';
			}else if(type == "building")
			{
				d_objTo = 'dstown2';
				d_dataTo = 'town';
			}
		}	//①세종시예외처리 끝
	}
	else if(obj.id == 'dscounty1'){
		d_dataFrom 	= 'county';
		d_objFrom		= 'dscounty1';
		d_objClear	= '';

		if(type == "road")
		{
			d_dataTo 		= 'rd_nm';
			d_objTo		= 'dsrd_nm1';
		}else if(type == "jibun")
		{
			d_objClear	= 'dsri1';
			d_objTo = 'dstown1';
			d_dataTo = 'town';
		}else if(type == "building")
		{
			d_objTo = 'dstown2';
			d_dataTo = 'town';
		}
	}else if(obj.id == 'dstown1')
	{
		d_dataFrom = 'town';
		d_objFrom = 'dstown1';
		d_objClear = '';
		 if(type == "jibun")
			{
				d_objTo = 'dsri1';
				d_dataTo = 'ri';
			}
	}

	else if(obj.id == 'dsrd_nm_idx1'){
		d_dataFrom 	= 'county';
		d_objFrom		= 'dscounty1';
		d_objClear	= '';
		d_dataTo 		= 'rd_nm';
		d_objTo		= 'dsrd_nm1';
	}else if(obj.id == 'dstown2')
	{
		d_objTo ='dsri1'; //임시
	}
	
	clearList1(d_objTo);
	
	//	clear해야 할 select가 설정된 경우 초기화
	if(d_objClear != ''){
	
		// 도로명 clear인 경우, 도로명 인덱스 선택 초기화
		if(d_objClear.indexOf("dsrd_nm") != -1){
			var rdIdxName = 'dsrd_nm_idx'+d_areaIdx;
			
			document.getElementById(rdIdxName).options[0].selected = true;
		}
	 	clearList1(d_objClear);
	}
	// from object 선택값이 없으면 return
	if(document.getElementById(d_objFrom).value == ''){
		return;
	}
	
	var url = "/getAreaCode.do?" + createParameter1() ;

  	createXMLHttpRequest();

 	xmlHttp.onreadystatechange = handleStateChange1;
  	xmlHttp.open("GET", url, true);
  	xmlHttp.send(null);
}

function handleStateChange1() {

	  if(xmlHttp.readyState == 4) {
	       if(xmlHttp.status == 200) {

	           		updateAreaList1();
	           		
	           	delete xmlHttp;
	           	xmlHttp = null;
	       }
	  }
	}
function createParameter1() {
	
	var rdIndex;
	
	// 도로명 clear인 경우, 도로명 인덱스 선택 초기화
	if(d_dataTo.indexOf("rd_nm") != -1){
	
		var rdIdxName = 'dsrd_nm_idx'+d_areaIdx;
		
		rdIndex = document.getElementById(rdIdxName).value;
	}
	
	var valFrom		= document.getElementById(d_objFrom).value;
	var valTo		= (d_objTo!='')?document.getElementById(d_objTo).value:'';
	//<![CDATA[
	//	시군구>도로명
	//	시도코드도 가져가야함
	if(d_dataFrom == 'county' && (d_areaIdx == 1 || d_areaIdx == 3)){
		var cityName = 'dscity'+d_areaIdx;
		var cityVal = document.getElementById(cityName).value;

		valFrom = cityVal+valFrom;

	}else if(d_dataFrom == 'town' && (d_areaIdx == 1 || d_areaIdx == 3)){
		var cityName	= 'dscity'+d_areaIdx;
		var countyName	= 'dscounty'+d_areaIdx;
		var cityVal = document.getElementById(cityName).value;
		if(cityVal=='36'){
			valFrom = '36110'+valFrom;
		}else
			valFrom = document.getElementById(cityName).value+document.getElementById(countyName).value+valFrom;
		}
	
	
	
/*
				//②세종시 예외처리
	if(encodeURI(valFrom)=='36'){
		valFrom +='110';
	}
*/
	var queryString = "from="+encodeURI(d_dataFrom)+"&to="+encodeURI(d_dataTo)+"&valFrom="+encodeURI(valFrom)+"&valTo="+valTo+"&rdIndex="+encodeURI(rdIndex);
	//alert(queryString+"2");

	return queryString;
}


/*
 *	지정된 행정구역코드 리스트를 초기화
 */
function clearList1(obj) {

		var toObject = document.getElementById(obj);
		  
		toObject.options.length = 0;
		if(document.getElementById('dscity1').value =='36' && obj =='dscounty1'){
			toObject.options[0] = new Option('', '110');
			$("#"+obj).parent().find(".select-title strong").text("");
		}
		else
		{
		   toObject.options[0] = new Option('::선택::', '');
		   $("#"+obj).parent().find(".select-title strong").text("::선택::");
		}
}
	
/*
 *	행정구역코드 리스트를 update
 */
function updateAreaList1() {

  var toObj 	= document.getElementById(d_objTo);
  var values 	= xmlHttp.responseXML.getElementsByTagName('value');
  var names 	= xmlHttp.responseXML.getElementsByTagName('name');
  var j = 1;

  //  리스트 수만큼 option을 달아준다
  for(var i = 0; i < values.length; i++) {
		
		if(isExceptArea(names[i].firstChild.nodeValue)){
			//alert(names[i].firstChild.nodeValue);
			j = j - 1;				
		}
		else{
			var option = new Option(names[i].firstChild.nodeValue, values[i].firstChild.nodeValue);
			option.title = names[i].firstChild.nodeValue;
       		toObj.options[i+j] = option;
       		
       		//alert("포함:"+values[i].firstChild.nodeValue);
       	}
   }
} 
function submitDetailSearch()
{
	var frm = document.getElementById("AKCFrm");
	var type = radioValue(frm.dssearchType1);
	
	frm.dsgubuntext.value = type; //구분코드 road, jibun, building
	frm.dscity1text.value = frm.dscity1.options[frm.dscity1.selectedIndex].text;
	frm.dscounty1text.value = frm.dscounty1.options[frm.dscounty1.selectedIndex].text;
	frm.dsemd1text.value = (type=="jibun")?frm.dstown1.options[frm.dstown1.selectedIndex].text:frm.dstown2.options[frm.dstown2.selectedIndex].text;
	frm.dsri1text.value = frm.dsri1.options[frm.dsri1.selectedIndex].value=="" ? "":frm.dsri1.options[frm.dsri1.selectedIndex].text;
	frm.dsrd_nm1text.value = frm.dsrd_nm1.options[frm.dsrd_nm1.selectedIndex].text;
	
	frm.dssan1text.value = (frm.dsch_san.checked==true)?1:0;
	
	
	
	
	
	
	
	//도로명주소 : 건물본번 입력 , 지번주소 : 본번입력 , 건물명: 건물 텍스트박스
	if(frm.dscity1text.value == "::선택::"){
		alert("시도를 선택하세요.");
		frm.dscity1.focus();
		return;
	}
	else if(frm.dscounty1text.value == "::선택::" && type != "building"){
			alert("시군구를 선택하세요.");
			frm.dscounty1.focus();
			return;
		}
	
	if(type == "road")
	{
		if(frm.dsrd_nm1text.value == "::선택::"){
			alert("도로명을 선택하세요.");
			frm.dsrd_nm1.focus();
			return;
		}
		else if(document.getElementById("dsma").value=="")
		{
			alert("건물 본번을 입력 하세요.");
			document.getElementById("dsma").focus();
			return;
		}
		
	}else if(type == "jibun")
	{
		if(frm.dsemd1text.value == "::선택::")
		{
			alert("읍면동을 입력 하세요.");
			frm.dstown1.focus();
			return ;
		}
		else if(document.getElementById("dsbun1").value=="")
		{
			alert("본번을 입력 하세요.");
			document.getElementById("dsbun1").focus();
			return ;
		}
		
	}else if(type == "building")
	{
		if(frm.dscounty1text.value == "::선택::")
		{
			frm.dscounty1text.value = "";
		}
		if(frm.dsemd1text.value == "::선택::")
		{
			frm.dsemd1text.value = "";
		}
		/*
		if(frm.dsemd1text.value == "::선택::")
		{
			alert("읍면동을 입력 하세요.");
			frm.dstown2.focus();
			return ;
		}*/
		document.getElementById("dsbuilding1").value=validateJuso(document.getElementById("dsbuilding1").value);
		if(document.getElementById("dsbuilding1").value=="")
		{
			alert("건물명을 입력 하세요.");
			document.getElementById("dsbuilding1").focus();
			return;
		}
	}
	
	//validateJuso
	
	
	frm.searchType.value="DETAIL";
    frm.action="/support/AddressMainSearch.do";

	frm.submit();
	
}
function radioValue(name)
{
	var radioLength = name.length;
	
	if(radioLength =="undefined")
	{
		radioLength=1;
	}
	for(var i=0; i<radioLength; i++)
	{
		if(name[i].checked == true)
		{
			return name[i].value;
		}
	}
	return 0;
}

function showDetailSearch()
{
	var frm = document.getElementById("AKCFrm");
    
	var type = radioValue(frm.dssearchType1);
	if(type =="road")
	{
		document.getElementById("detailSearchRoadTb").style.display="block";
		document.getElementById("detailSearchJibunTb").style.display="none";
		document.getElementById("detailSearchBuildingTb").style.display="none";
	}else if(type == "jibun")
	{
		document.getElementById("detailSearchRoadTb").style.display="none";
		document.getElementById("detailSearchJibunTb").style.display="block";
		document.getElementById("detailSearchBuildingTb").style.display="none";
	}else{
		document.getElementById("detailSearchRoadTb").style.display="none";
		document.getElementById("detailSearchJibunTb").style.display="none";
		document.getElementById("detailSearchBuildingTb").style.display="block";
	}
	resetDetailSearch();
}

function resetDetailSearch()
{
	document.getElementById("dscity1").options[0].selected=true;
	$("#dscity1").parent().find(".select-title strong").text("::선택::");
	document.getElementById("dscounty1").disabled = false;  //세종시일경우 disabled시킴
	clearList1('dscounty1');
	clearList1('dsrd_nm1');
	clearList1('dstown1');
	clearList1('dsri1');
	clearList1('dstown2');
	
	document.getElementById("dsbun1").value="";
	document.getElementById("dsbun2").value="";
	document.getElementById("dsma").value="";
	document.getElementById("dssb").value="";
	document.getElementById("dsbuilding1").value="";
	
	//ㄱ,ㄴ,ㄷ,ㄹ , 산
	document.getElementById("dsrd_nm_idx1").options[0].selected=true;
	$("#dsrd_nm_idx1").parent().find(".select-title strong").text("ㄱ");
	
	document.getElementById("dsch_san").checked=false;
}

/*전자지도 상세주소 */
/*
function viewDetailBldInfo(gubun,id)
{
	var url = "/search/getAddrDongDetail.do?bdMgtSn=" + id ;
	createXMLHttpRequest();
 	xmlHttp.onreadystatechange = viewDetailhandleStateChange;
  	xmlHttp.open("GET", url, true);
  	xmlHttp.send(null);
}
function viewDetailhandleStateChange()
{
	if(xmlHttp.readyState == 4) {
	       if(xmlHttp.status == 200) {
	    	   	alert(xmlHttp.responseXML);
	       	}
	}
}
*/

/****** S: 지역별 도로명검색*******/
var prevPosition = 0;
function clearRdNmList(){
	$('#roadNameList').text("");
	$('#selectRdNm').val("");
	$('#roadNameList2 li').remove();
	$('#roadNameList2 div').css('display','none');
	$.each($('.cons a'),function(){ $(this).unbind('click',false);});
	$('#roadNameList2').scrollTop(0);
	prevPosition = 0;

	//초성인덱스 비활성화
	$(".dic_list a").removeClass("press");
	$(".dic_list li").removeClass("on");
	//도로명이 결과값 리스트 비활성화 
	$(".dic_content dl").addClass("blind");
}

function changeAreaList2(idx, obj){
	if(obj.id == '' || obj.id == 'undefined')
	return;

	d_areaIdx = idx;
	if(obj.id == 'rdnmcity1'){
		d_dataFrom 	= 'city';
		d_dataTo 	= 'county';
		d_objFrom	= 'rdnmcity1';
		d_objTo		= 'rdnmcounty1';
		d_objClear	= 'rdnmcounty1';
		

		document.getElementById("rdnmcounty1").disabled = false;
		if(document.getElementById(obj.id).value =='36'){
			document.getElementById("rdnmcounty1").disabled = true;
			d_dataFrom 	= 'county';
			d_objFrom		= 'rdnmcounty1';
			d_objClear	= 'rdnmcounty1';
			d_objTo = 'rdnmcounty1';
			d_dataTo = 'rd_nm';
			
		}	//①세종시예외처리 끝
	}else if(obj.id == 'rdnmcounty1'){
		d_dataFrom 	= 'county';
		d_objFrom = 'rdnmcounty1';
		d_objClear	= '';
		d_dataTo = 'rd_nm';
		d_objTo	= '';
		
	}
	clearList2(d_objTo);
	clearRdNmList();
	
	if(document.getElementById(d_objFrom).value == ''){
		return;
	}
	
	var url = "/getAreaCode.do?" + createParameter2() ;
  	createXMLHttpRequest();

 	xmlHttp.onreadystatechange = handleStateChange2;
  	xmlHttp.open("GET", url, true);
  	xmlHttp.send(null);
}

function handleStateChange2() {

	  if(xmlHttp.readyState == 4) {
	       if(xmlHttp.status == 200) {

           		updateAreaList3();
	           		
	           	delete xmlHttp;
	           	xmlHttp = null;
	       }
	  }
}

function clearList2(obj) {
	if(obj=='' || obj ==null){
		return;
	}
	var toObject = document.getElementById(obj);
	toObject.options.length = 0;
	if(document.getElementById('rdnmcity1').value =='36' && obj =='rdnmcounty1'){
		toObject.options[0] = new Option('', '110');
	}
	else
	{
	   toObject.options[0] = new Option('::선택::', '');
	   $("#"+obj).parent().find(".select-title strong").text("::선택::");
	}
}
function createParameter2(areaIdx) {
	$(".dic_list li").removeClass("on");
	var rdIndex="";

	var valFrom		= document.getElementById(d_objFrom).value;
	var valTo = "";
	if(d_dataTo != 'rd_nm'){
		valTo = (d_objTo!='')?document.getElementById(d_objTo).value:'';
	}

	//	시군구>도로명
	if(d_dataFrom == 'county' && (d_areaIdx == 1 || d_areaIdx == 3)){
		var cityName = 'rdnmcity'+d_areaIdx;
		var cityVal = document.getElementById(cityName).value;
		
		valFrom = cityVal+valFrom;
	}
	

	//②세종시 예외처리
	if(encodeURI(valFrom)=='36'){
		valFrom +='110';
	}

	var queryString = "from="+encodeURI(d_dataFrom)+"&to="+encodeURI(d_dataTo)+"&valFrom="+encodeURI(valFrom)+"&valTo="+valTo;

	return queryString;
}

function cho_hangul(str){
	var cho=["ㄱ", "ㄲ", "ㄴ", "ㄷ","ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"];
	var result="";
	for(var i=0; i<str.length;i++){
		code = str.charCodeAt(i)-44032;
		if(code>-1 && code<11172) result+=cho[Math.floor(code/588)];
	}
	return result;
}

function updateAreaList3() {
	var toObj ="";
	if(d_objTo!=''){
		toObj 	= document.getElementById(d_objTo);
	}
	
	var values 	= xmlHttp.responseXML.getElementsByTagName('value');
	var names 	= xmlHttp.responseXML.getElementsByTagName('name');
	var roadNameCd 	= xmlHttp.responseXML.getElementsByTagName('namecd');
	var searchResult = "";
	var j = 1;
	
	var check = $('#rdnmcity1').val();
	var letter ="";
	 //  리스트 수만큼 option을 달아준다
	if(values.length < 1){
		$('#roadNameList').text('검색 결과가 없습니다.');
		return;
	}
	
	for(var i = 0; i < values.length; i++) {
		
		if(isExceptArea(names[i].firstChild.nodeValue)){
			j = j - 1;
		}
		else{
			if(d_objTo != null && d_objTo !="" && check!='36'){
				var option = new Option(names[i].firstChild.nodeValue, values[i].firstChild.nodeValue);
				option.title = names[i].firstChild.nodeValue;
	       		toObj.options[i+j] = option;
			}else{
				searchResult += names[i].firstChild.nodeValue +"|"+ roadNameCd[i].firstChild.nodeValue+"$";
				letter= cho_hangul(names[i].firstChild.nodeValue.substring(0,1));
				
				if(letter == ""){
					letter = "1,#";
				}else if(letter=="ㄲ"){
					letter = "ㄱ";
				}else if( letter=="ㄸ"){
					letter = "ㄷ";
				}else if( letter=="ㅃ"){
					letter = "ㅂ";
				}else if(letter=="ㅆ"){
					letter = "ㅅ";
				}else if(letter=="ㅉ"){
					letter = "ㅈ";
				}
				
				$(".dic_content dt:contains('"+letter+"')").next().find("ul").append("<li><button href='#listRdnm' onclick='javascript:txtSet(this);'>"+names[i].firstChild.nodeValue+"</button></li>");
			}
	    }
	}
	
	
	if(searchResult != null ){
		$('#rdnmSearchResult').val(searchResult);
	}
	
	//초성인덱스 href 모두 제거
	$("#search_country .dic_list a").removeAttr('href');
	
	//도로명이 존재하는 초성인덱스 활성화
	$(".dic_content button").parents('dd').prev().each(function (index){
		$(".dic_list a[data-list_code='"+$(this).attr('id')+"']").addClass('press').attr("href", "#"+$(this).attr('id'));
	});
	
	//도로명 결과값 존재하는 리스트 활성화
	$("#search_country .dic_content button").parents("dl.blind").removeClass("blind");
	
} 

//선택한 도로명 배경색으로 표시
function txtSet(obj){
	var txt ="";
	txt =$('#rdnmcity1 option:selected').text()+" "+$('#rdnmcounty1 option:selected').text()+" "+$(obj).text();
	$('#addrValue').val(txt);
	$('#roadNameList2 ul').children().removeAttr('style');
	//$(obj).parent('li').parent('ul').children('li').removeAttr('style');
	$(obj).parent('li').css('background-color','#DCE9F9');
	$('#addrValue').focus();
	
}

//도로명 조회 결과 엑셀다운로드
function excelDown(fileType){
	var city =$('#rdnmcity1').val();
	var country = $('#rdnmcounty1').val();
	if(city==null || city==''){
		alert("시도를 선택해주세요.");
		$('#rdnmcity1').focus();
		return;
	}else if(city!='36'&&(country==null || country=='')){
		alert("시군구를 선택해주세요.");
		$('#rdnmcounty1').focus();
		return;
	}
	if(city!='36'){
		$('#sigCd').val(city+country);
	}else{
		$('#sigCd').val('36110');
	}
	
	$('#sidoResult').val($('#rdnmcity1 option:selected').text());
	$('#sigunguResult').val($('#rdnmcounty1 option:selected').text());
	
	var excelForm = document.excelForm;
	excelForm.action = "/getAreaCode.do";
	excelForm.userDownType.value = fileType;
	excelForm.submit();
}
/****** E: 지역별 도로명검색*******/

//특수문자, 특정문자열(sql예약어) 제거
function checkSearchedWord(obj){
	obj.value=trim(obj.value+" ");
	
	//특수문자 제거
	if(obj.value.length >0){
		var expText = /[%=><]/ ;
		if(expText.test(obj.value) == true){
			alert("특수문자를 입력 할수 없습니다.") ;
			obj.value = obj.value.split(expText).join(""); 
			return false;
		}
		
		//체크 문자열
		var sqlArray = new Array(
				//sql 예약어
				"OR",     "SELECT", "INSERT", "DELETE", 
				"UPDATE", "CREATE", "DROP",   "EXEC",
                "UNION",  "FETCH", "DECLARE", "TRUNCATE"
		);
		
		var regex ;
		var regex_plus ;
		var regex_all ;
		for(var i=0; i<sqlArray.length; i++){
			
			regex = new RegExp("\\s" + sqlArray[i] + "\\s","gi") ;
			
			if (regex.test(obj.value)) {
			    alert("\"" + sqlArray[i]+"\"와(과) 같은 특정문자로 검색할 수 없습니다.");
				obj.value =obj.value.replace(regex, "").trim();
				return false;
			}
			
			regex_plus = new RegExp( "\\+" + sqlArray[i] + "\\+","gi") ;

			if (regex_plus.test(obj.value)) {
			    alert("\"" + sqlArray[i]+"\"와(과) 같은 특정문자로 검색할 수 없습니다.");
				obj.value =obj.value.replace(regex_plus, "").trim();
				return false;
			}
			
		}

	}
	
	return true ;
}

//영문용 : 특수문자, 특정문자열(sql예약어) 제거
function checkSearchedWordEng(obj){
	obj.value=trim(obj.value+" ");
	
	//특수문자 제거
	if(obj.value.length >0){
		var expText = /[%=><]/ ;
		if(expText.test(obj.value) == true){
			alert("You can't input special characters") ;
//			alert("특수문자를 입력 할수 없습니다.") ;
			obj.value = obj.value.split(expText).join(""); 
			return false;
		}
		
		//체크 문자열
		var sqlArray = new Array(
				//sql 예약어
				"OR",     "SELECT", "INSERT", "DELETE", 
				"UPDATE", "CREATE", "DROP",   "EXEC",
                "UNION",  "FETCH", "DECLARE", "TRUNCATE"
		);
		
		var regex ;
		var regex_plus ;
		for(var i=0; i<sqlArray.length; i++){
			
			regex = new RegExp("\\s" + sqlArray[i] + "\\s","gi") ;
			
			if (regex.test(obj.value.toUpperCase())) {
			    alert("You can't search for words with certain letters like \"" + sqlArray[i] +"\".");
//			    alert("\"" + sqlArray[i]+"\"와(과) 같은 특정문자로 검색할 수 없습니다.");
				obj.value =obj.value.replace(regex, "").trim();
				return false;
			}
			
			regex_plus = new RegExp( "\\+" + sqlArray[i] + "\\+","gi") ; 

			if (regex_plus.test(obj.value.toUpperCase())) {
			    alert("You can't search for words with certain letters like \"" + sqlArray[i] +"\".");
//			    alert("\"" + sqlArray[i]+"\"와(과) 같은 특정문자로 검색할 수 없습니다.");
				obj.value =obj.value.replace(regex_plus, "").trim();
				return false;
			}

		}

	}
	
	return true ;
}


//////////////////////신규추가///////////////////////////////
//가이드북 보기
function openGuideBookBrowser(type){
	/*var sWidth = screen.availWidth;
	var sHeight = screen.availHeight;
	window.open('/CommonPageLink.do?link=/street/guide-book', '도로명주소 소개', 'width='+sWidth+',height='+sHeight+',left=0,top=0,menubar=no,scrollbars=no,resizable=yes,directiories=no,stasut=no');*/
	var w = screen.availWidth;
	var h = screen.availHeight-100;
	if(type =='kor'){
		window.open('/CommonPageLink.do?link=/street/GuideBook', '도로명주소_소개', 'width='+w+',height='+h+',left=0,top=0, menubar=no,status=no,directiories=no');
	}else if(type == 'eng'){
		window.open('/CommonPageLink.do?link=/eng/about/GuideBook', 'Introduction', 'width='+w+',height='+h+',left=0,top=0, menubar=no,status=no,directiories=no');
	}
}

//아름다운 건물번호판
function openJusoDesignBookBrowser(){
	var w = screen.availWidth;
	var h = screen.availHeight-100;
	
	window.open('/CommonPageLink.do?link=/jusoDesign/jusoDesignBook', '아름다운_건물번호판', 'width='+w+',height='+h+',left=0,top=0, menubar=no,status=no,directiories=no');
}



//validation
function validate(value){
	var specialChars =/[~!#$^@%&*+=|:;?"<,>']/;
	var tmpValue = value.split(specialChars).join("");
	
	if (value != tmpValue) {
		alert("!,@,#,$,%와 같은 특수문자는 검색조건으로 사용할 수 없습니다.");
	}
	
	return tmpValue; 
/*		
	if (value != "" && value != null && value!=value.split(specialChars)) {
		return false;
	} else {
		value = value.split(specialChars).join("");
		return true;
	}
*/		
}

function validate2(value){
	var specialChars =/[~!#$^@%&*+=|:;?"<,>']/;
	var tmpValue = value.split(specialChars).join("");
	if (value != tmpValue) {
		alert("!,@,#,$,%와 같은 특수문자는 검색조건으로 사용할 수 없습니다.");
		return true;
	}else{
		return false;
	}
}

//ajax request
var xmlHttp = null;
function sendRequest(callback,method,httpUrl,param)
{
	 xmlHttp = getXMLHttpRequest();
	 xmlHttp.open(method, httpUrl, true);
	 xmlHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded;charset=UTF-8");
	 xmlHttp.onreadystatechange = callback;

	 xmlHttp.send(param);
}

function setEncHeader(oj){
	var contentTypeUrlenc = 'application/x-www-form-urlencoded; charset=UTF-8';
	if(!window.opera){
		oj.setRequestHeader('Content-Type',contentTypeUrlenc);
	} else {
		if((typeof oj.setRequestHeader) == 'function')
			oj.setRequestHeader('Content-Type',contentTypeUrlenc);
		} 
	return oj;
}

//통계 차트 자료 ajax 통신
function chartChange(type1, type2, obj){

	var statsYm ="";
	var sidoCd = "";
	var sigCd = "";
	var choiceYm ="";
	var sidokorNm ="";
	var statsCd = "";
	
	$('#type').val(type2);//검색을 진행했다는 flag DOM
	
	if(type1 == 'juso'){//도로명주소 진입
		if(type2 == 'reg'){
			//시도가 바뀌었을떄만 시군구 리스트를 초기화 해주기 위한 변수
			if(obj.id =='sidoCdSelect'){
				$('#sigFlag').val('1');
			}
			else if(obj.id == 'sigCdSelect'){
				$('#sigFlag').val('0');
			}
			
			statsYm = document.getElementById("statsYm").value;	
			sidoCd = document.getElementById("sidoCdSelect").value;		
			sigCd = document.getElementById("sigCdSelect").value;
			
			if (sidoCd == "36" && obj.id == 'sidoCdSelect') {
				sigCd = "36110";
			}
			
			$('#sigCd').val(sigCd);
			$('#sidoCd').val(sidoCd);
			$('#statsYm').val(statsYm);
		}
		else{
			
			statsYm = document.getElementById("statsYmAuth").value;	
			choiceYm = document.getElementById("choiceYm").value;		
			sidoCd = document.getElementById("sidoCdSelectAuth").value;		
			sigCd = document.getElementById("sigCdSelect").value;
			
			$('#statsYmAuth').val(statsYm);
			$('#sidoCdAuth').val(sidoCd);
			$('#sigCdAuth').val(sigCd);
		}
		
	}
	else if(type1 =='road'){//도로명 진입
		if(type2 == 'reg'){

			statsYm = $('#statsYmSelect').val();//기준년월
			sidoCd = $('#sidoCdSelect').val();//시도코드
			/* 엑셀 폼값 변수 세팅 */
			$('#statsYm').val(statsYm);
			$('#sidoCd').val(sidoCd);
			
			statsCd = "0200";
			
		}
		else{
			statsCd = $('#choiceStatsCdAuth').val();
			sidoCd = $('#choiceSidoCdAuth').val();
			sidokorNm = $('#choiceSidoCdAuth').find("option[value='"+sidoCd+"']").text();
			
			$('#statsCd').val(statsCd);
			$('#sidoCdAuth').val(sidoCd);
			$('#sidokorNm').val(sidokorNm);	
	
			if(statsCd == "" && sidoCd == ""){
				$('#type').val("");
			}	
		}
	}
	else if(type1 =='bas'){
		
		statsYm = document.getElementById("statsYm").value;		
		sidoCd = document.getElementById(obj.id).value;
		
		$('#sidoCdSelect').val(sidoCd).attr('selected',"selected");
		$('#sidoCd').val(sidoCd);
		$('#focusDiv').focus();
	}
	
	var vUrl = "/statis/statisChartData.do";
	
	$.ajax({
		url:vUrl,
		type : "POST",
		data : {
				type1: type1,
				type2: type2,
				statsCd : statsCd , 
			    statsYm : statsYm , 
			    sidoCd : sidoCd, 
			    sidokorNm : sidokorNm,
			    choiceYm : choiceYm,
			    sigCd : sigCd
			   },
		success: function (response){

			chageChartSuccess(response,type1, type2, sidoCd, sigCd, statsYm, choiceYm, sidokorNm, statsCd, obj);
			
		}, 
		error : function(error){
			alert('통계 데이터를 조회중 오류가 발생하였습니다.');
		}
		
	});
}
function chageChartSuccess(response,type1, type2, sidoCd, sigCd, statsYm, choiceYm, sidokorNm, statsCd, obj) {

	var rowNum = 0;
	var sido = "";
	var jusoCnt = 0;
	var boardData = "";
	var listSize = parseInt($(response).find("listSize").text());
	var stYm = $(response).find("stYm").text();
	var edYm = $(response).find("edYm").text();
	var basicDataFlag =true;//기본데이터 세팅반복 제외를 위한 변수
	var type1 = type1;
	var type2 = type2;
	
	//지역별일 경우 시군구 세팅하는 부분
	if(type1 == 'juso' && type2 =='reg' ){

		var toObject = document.getElementById('sigCdSelect');
		var sigFlag = $('#sigFlag').val();//시구 리스트가 없을때만 리스트 세팅을위한 변수
		
		if(type1 == 'juso' && type2 =="reg" && sidoCd != "" && sigFlag == '1'){
			
			//시구 리스트 초기화 시켜주기
			clearListStatis('sigCdSelect');
		
			$(response).find("sigList").each(function(index){
				
				resultCd = $(this).find('resultCd').text();
				sigCd = $(this).find('sigCd').text();
				sigKorNm = $(this).find('sigKorNm').text();
				
				var option = new Option(sigKorNm, sigCd);
				option.title = sigKorNm;
	       		$('#sigCdSelect').append(option);		
			});
		}
	}
	
	if(type1 =='road' && type2 == ''){
		var jusoCnt = $('.totalCount').text();
		$(".totalCount").html("전체 : "+jusoCnt) ;
	}
	
	//차트 데이터 초기화 및 세팅
	graphData.splice(0, graphData.length);
	$('#stYm').val(stYm);
	$('#edYm').val(edYm);
	$('#regDataTable').html("");
	$('#authDataTable').html("");
	
	
	/* 상황에따른 테이블 데이터 세팅 및 그레프 세팅  */
	boardData = boardData + "<table id='statsTable' name='regDataOne'>";
	
	var strCaption = "";
	if(type1 == "juso"){
		strCaption = "도로명주소통계";
		
		if(type2 == "reg"){
			strCaption = strCaption + " - 지역별";
		} else {
			strCaption = strCaption + " - 부여시기별";
		}
		
	} else if(type1 == "road"){
		strCaption = "도로명통계";
		
		if(type2 == "reg"){
			strCaption = strCaption + " - 지역별";
		} else {
			strCaption = strCaption + " - 부여사유별";
		}
		
	} else {
		strCaption = "기초구역통계 - 지역별";
	}
	boardData = boardData + "<caption>"+strCaption+" 통계자료 표</caption>";
	
	if(listSize == 2){
		boardData = boardData + '<colgroup>';
		boardData = boardData + 	'<col width="10%">';
		boardData = boardData + 	'<col width="40%">';
		boardData = boardData + 	'<col width="50%">';
		boardData = boardData + '</colgroup>';
		boardData = boardData + '<thead>';
		boardData = boardData + 	'<tr>';
		boardData = boardData + 		'<th scope="col">연번</th>';
		boardData = boardData + 		'<th scope="col">구분</th>';
		boardData = boardData + 		'<th scope="col">도로수</th>';
		boardData = boardData + 	'</tr>';
		boardData = boardData + '</thead>';
	}
	else if(type1 =='road'  && type2 =='auth' && statsCd == "" && sidokorNm != '전체'){
		boardData = boardData + '<colgroup>';
		boardData = boardData + 	'<col width="17%">';
		boardData = boardData + 	'<col width="17%">';
		boardData = boardData + 	'<col width="17%">';
		boardData = boardData + 	'<col width="17%">';
		boardData = boardData + 	'<col width="17%">';
		boardData = boardData + 	'<col width="15%">';
		boardData = boardData + '</colgroup>';
		boardData = boardData + '<thead>';
		boardData = boardData + 	'<tr>';
		boardData = boardData + 		'<th scope="col">시도</th>';
		boardData = boardData + 		'<th scope="col">지명·자연마을이름</th>';
		boardData = boardData + 		'<th scope="col">행정구역 명칭</th>';
		boardData = boardData + 		'<th scope="col">역사적인물·기념</th>';
		boardData = boardData + 		'<th scope="col">문화재·유적</th>';
		boardData = boardData + 		'<th scope="col">기타</th>';
		boardData = boardData + 	'</tr>';
		boardData = boardData + '</thead>';
	}
	else if(type2 =='auth'&& statsCd == "" && listSize =='90'){
		boardData = boardData + '<colgroup>';
		boardData = boardData + 	'<col width="15%">';
		boardData = boardData + 	'<col width="15%">';
		boardData = boardData + 	'<col width="14%">';
		boardData = boardData + 	'<col width="14%">';
		boardData = boardData + 	'<col width="14%">';
		boardData = boardData + 	'<col width="14%">';
		boardData = boardData + '</colgroup>';
		boardData = boardData + '<thead>';
		boardData = boardData + 	'<tr>';
		boardData = boardData + 		'<th scope="col">시도</th>';
		boardData = boardData + 		'<th scope="col">지명·자연마을이름</th>';
		boardData = boardData + 		'<th scope="col">행정구역 명칭</th>';
		boardData = boardData + 		'<th scope="col">역사적인물·기념</th>';
		boardData = boardData + 		'<th scope="col">문화재·유적</th>';
		boardData = boardData + 		'<th scope="col">기타</th>';
		boardData = boardData + 	'</tr>';
		boardData = boardData + '</thead>';
	}
	else{
		boardData = boardData + '<colgroup>';
		boardData = boardData + 	'<col width="10%">';
		boardData = boardData + 	'<col width="20%">';
		boardData = boardData + 	'<col width="20%">';
		boardData = boardData + 	'<col width="10%">';
		boardData = boardData + 	'<col width="20%">';
		boardData = boardData + 	'<col width="20%">';
		boardData = boardData + '</colgroup>';
		boardData = boardData + '<thead>';
		boardData = boardData + 	'<tr>';
		boardData = boardData + 		'<th scope="col">연번</th>';
		boardData = boardData + 		'<th scope="col">구분</th>';
		boardData = boardData + 		'<th scope="col">도로수</th>';
		boardData = boardData + 		'<th scope="col">연번</th>';
		boardData = boardData + 		'<th scope="col">구분</th>';
		boardData = boardData + 		'<th scope="col">도로수</th>';
		boardData = boardData + 	'</tr>';
		boardData = boardData + '</thead>';
	}
	boardData = boardData + "<tbody>";
	
	
	/* 그래프 값 푸쉬및 tbody 생성  */
	var rowNum = 0;
	$(response).find("data").each(function(index){
			
		//rowNum = $(this).find('rowNum').text();
		sido = $(this).find('sido').text() == "센터" ? "행정안전부" :  $(this).find('sido').text() ;
		jusoCnt = $(this).find('jusoCnt').text();
		resultCd = $(this).find('resultCd').text();
			
		if (resultCd != "00" || ( resultCd == 00 &&  sido == "행정안전부" )) {
			rowNum++;
			/* 그래프 배열 밀어주기 if문 */
			if(type1 == 'juso' && type2 == "reg"){
				graphDataOrigin.push([sido, parseInt(jusoCnt, 10)]);
			}
			else{
				graphData.push([sido, parseInt(jusoCnt, 10)]);
			}
			
			jusoCnt =numberFormat(jusoCnt);//콤마찍기
			//rowNum = rowNum-1;//통계자료 표 인덱스

			var flag1 = true;//데이터의 테이블 삽입 여부 구분

			
			if(listSize == 2){
				
				boardData = boardData +	"<tr><td>"+rowNum+"</td><td>"+sido+"</td><td>"+jusoCnt+"</td>";
				
			}
			else if(type1 =='road'  && type2 =='auth' && statsCd == "" && sidokorNm != '전체'){

				if(index == 1){
					boardData = boardData +	"<tr><td>"+sidokorNm+"</td><td>"+jusoCnt+"</td>";	

				}
				else if(index == listSize+1){			
					boardData = boardData +	"</tr>";
					
				}
				else{
					boardData = boardData +	"<td>"+jusoCnt+"</td>";
				}
	
			}
			else if(type2 =='auth' && statsCd == "" && type1 =='road'){
				
				if( basicDataFlag ==true ){//도로명별 특수그래프
					$(response).find("basicData").each(function(index){
						
						var korNm = $(this).find('korNm').text();
						var reg0410 = numberFormat($(this).find('reg0410').text());
						var reg0420 = numberFormat($(this).find('reg0420').text());
						var reg0440 = numberFormat($(this).find('reg0440').text());
						var reg0450 = numberFormat($(this).find('reg0450').text());
						var reg0499 = numberFormat($(this).find('reg0499').text());
						var resultCd = $(this).find('resultCd').text();
						var korNm = $(this).find('korNm').text() == "센터" ? "행정안전부":$(this).find('korNm').text();
						var jusoCnt = $(this).find('jusoCnt').text();
						
						if (resultCd != "00"  || ( resultCd  =="00"  && korNm =="행정안전부")  ) {
							boardData = boardData + "<tr><td>"+korNm+"</td><td>"+reg0410+"</td><td>"+reg0420+"</td>";
							boardData = boardData + "<td>"+reg0440+"</td><td>"+reg0450+"</td><td>"+reg0499+"</td></tr>";
						}
						if (resultCd == "00" && korNm =="TOTAL_CNT") {
							jusoCnt =numberFormat(jusoCnt);
							$(".totalCount").html("전체 : "+jusoCnt) ;
						}
					});
					basicDataFlag = false;
				}
			}
			else{
				if(rowNum%2 > 0 && flag1 == true){
					
					boardData = boardData +	"<tr><td>"+rowNum+"</td><td>"+sido+"</td><td>"+jusoCnt+"</td>";	
					
					if(index == listSize-1){
						boardData = boardData +	"<td></td><td></td><td></td></tr>";
					}
					flag1 = false;
					
				}
				else if(rowNum%2 == 0 && flag1 == true){
					
					boardData = boardData + "<td>"+rowNum+"</td><td>"+sido+"</td><td>"+jusoCnt+"</td></tr>";
					
				
				}
			}
			
		}
		/* 전체 게시물수 세팅 */
		if(resultCd == "00" && sido =="TOTAL_CNT" ){
			
			jusoCnt =numberFormat(jusoCnt);
			if(type1 =='juso' && type2 =='auth'){
				var stYear = stYm.substr(0,4);
				var stMonth = stYm.substr(4,6);
				var edYear = edYm.substr(0,4);
				var edMonth = edYm.substr(4,6);
				document.getElementById('countJuso').innerHTML="기준일자 : "+stYear+"년 "+stMonth+"월 ~ "+edYear+"년 "+edMonth+"월&nbsp;&nbsp;|&nbsp;&nbsp;<span style='font-weight:bold;' class='totalCount'>전체 : "+jusoCnt+"</span>" ;
			}
			else{
				$(".totalCount").html("전체 : "+jusoCnt) ;
			}
		}
	});
	
	boardData = boardData + "</tbody>";
	boardData = boardData + "</table>";

	/* 세종시일경우의 pieGraph 설정 */
	seajongException(type1, type2, sidoCd, obj);
	
	
	/* 상황에따른 table Toggle과 데이터 삽입 */
	if(type2 == 'reg'){	
		$('#regDataTable').html(boardData);

	}
	else if(type2 == 'auth'){
		$('#authDataTable').html(boardData);
	}
	
	
	$('#choiceSidoCdAuth').attr('disabled',true);//셀렉트박스 활성화 조건
	if(type1 == 'road' && statsCd == "" && sidoCd == ""){//도로명의 특수한경우

		roadGraph(type2,"");
		$('#choiceSidoCdAuth').attr('disabled',false);//셀렉트박스 활성화 조건
	}
	else{
		roadGraph(type2,'search');
		if(statsCd != ''){
			$('#choiceSidoCdAuth').val("").attr('selected',"selected");
			$('#choiceSidoCdAuth').attr('disabled',true);//셀렉트박스 활성화 조건
		}
		else{
			$('#choiceSidoCdAuth').attr('disabled',false);//셀렉트박스 활성화 조건	
		}
	}
}
/* 콤마 찍어주기 */
function numberFormat(inputNumber) {
	return inputNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g,",");
}
/* 시군구 리스트 초기화 */
function clearListStatis(obj) {

	var toObject = document.getElementById(obj);
	toObject.options.length = 0;
	toObject.options[0] = new Option('선택', '');
	$("#"+obj).parent().find(".select-title strong").text("선택");

}
/* 세종시 예외처리(필요에따라 조건 추가) */
function seajongException(type1, type2, sidoCd, obj) {
	
	$('.pie').attr("style","display:block;cursor:pointer;");
	if(type1 =='juso'){
		
		if (sidoCd == "36") {
			
			if(type2 == 'reg' && obj.id =='sidoCdSelect'){
				$('#sigCdSelect').val("36110").attr("selected","selected");
			}
			/*else{
				//$('.pie').attr("style","display:none;");
			}*/
		} 
		else {
			$('.pie').attr("style","display:block;");
		} 
			
	}
	/*if(type1 =='road' && type2=='reg'){
		if (sidoCd == "36") {
			$('.pie').attr("style","display:none;");
		} 
		else {
			$('.pie').attr("style","display:block;cursor:pointer;");
		} 
	}
	if(type1 =='bas'){
		if (sidoCd == "36") {
			$('.pie').attr("style","display:none;");
		} 
		else {
			$('.pie').attr("style","display:block;cursor:pointer;");
		} 
	}*/
}
function graphStyleToggle(obj, saveStyle, graphStyle){
	
	var ulTagId = $(obj).parent().parent().attr('id');
	var objClass = $(obj).attr('class');
	var objText;
	
	/* 그래프스타일 active 이벤트 */
	$('#'+ulTagId+' li').each(function(index,item){
		
		var graphStyle = $(this).children().attr('class');
		var exp = /active/ ;
		var exp2 = new RegExp(objClass);
		
		if(exp2.test(graphStyle) == true){//본인일떄
			objText = $(obj).text();
			objText = objText.split(" ");
			
			if(exp.test(graphStyle) == false ){//active가 없으면
				
				graphName =  objText[0].substring(0,objText[0].length-1);
				$(this).children().addClass('active').text(graphName + " 표출");

			}
			else{

				graphName =  objText[0].substring(0,objText[0].length);
				$(this).children().addClass('active').text(graphName + " 표출");
			}
		}
		else{//본인이 아닐때
			objText = $(this).children().text();
			objText = objText.split(" ");
			
			if(exp.test(graphStyle) == true ){//active가 있으면
				graphName =  objText[0].substring(0,objText[0].length);
				
				$(this).children().text(graphName+"로 보기");
				$(this).children().removeClass('active');

			}
			else{
				graphName =  objText[0].substring(0,objText[0].length-1);
				$(this).children().text(graphName+"로 보기");
			}
		}
	});
	
	/* 그래프스타일을 저장해주는 변수에 값을 저장 */
	$('#'+saveStyle).val(graphStyle);

}

/* 첨부파일 전체 다운로드 */
function fileDnAll(objName, btnId, paramNm){
    
    var links = document.getElementsByName(objName);
    var hrefs = [];
    for(var i= 0 ; i < links.length; i++ ){
	//href속성의 맨 마지막 파라미터가 첨부파일 등록년도 여야 함
	var regDt = links[i].href.substr(links[i].href.lastIndexOf('='), links[i].href.length -1).replace('=','');
	hrefs.push(regDt);
		
    };
    var dnAllHref = document.getElementById(btnId).href;
    var dnAllHref = dnAllHref + "&"+paramNm+"="+hrefs;
    document.getElementById(btnId).href = dnAllHref;
}
