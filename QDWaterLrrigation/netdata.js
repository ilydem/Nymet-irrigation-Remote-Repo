/***
 *js¥˙¬Î π”√µƒ∑˛ŒÒ∆˜Œ™:http://sainthsktoo.xicp.net:70/Watering/
 *
 *
 *
 *version is 1.0
 *code is by ljguo
 */
//ªÒ»°µ±«∞µƒ“≥√ÊµƒÕÍ’˚µÿ÷∑
var url=window.location.href;
/**
 *ªÒ»°alluser.jsp“≥√ÊµƒAll State±Ìµƒ ˝æ›
 */
function getAlluserOfAllState(){
    var str='[';
    var table=document.getElementsByTagName('table')[0];
    var rowsLength=table.rows.length;
    for(i=2;i<rowsLength-1;i++){
        str+='{'
        str+='\"licenseNumber\":\"'+table.rows[i].cells[1].innerText+'\",';
        str+='\"state\":\"'+table.rows[i].cells[2].innerText+'\"'
        str+='}'
        if(i<rowsLength-2){
            str+=','
        }
    }
    str+=']'
    return str;
}


/**
 *ªÒ»°summary.jsp“≥√ÊµƒState±Ìµƒ ˝æ›
 */
function getSummaryOfState(){
    var table=document.getElementsByTagName('table')[5];
    var str='{';
    str+='\"programType\":\"'+table.rows[1].cells[1].innerText+'\",';
    str+='\"moisture\":\"'+table.rows[3].cells[1].innerText+'\",';
    str+='\"rain\":\"'+table.rows[4].cells[1].innerText+'\"';
    str+='}';
    return str;
}
/**
 *ªÒ»°summary.jsp“≥√Êµƒsummary±ÌµƒMasterValve ˝æ›
 */
function getSummaryOfSummaryByMasterValve(){
    var table=document.getElementsByTagName('table')[5];
    var str='{';
    str+='\"totalWaterUsed\":\"'+table.rows[2].cells[2].innerText+'\",';
    str+='\"currentFlow\":\"'+table.rows[2].cells[4].innerText+'\"';
    str+='}';
    return str;
}
/**
 *ªÒ»°summary.jsp“≥√Êµƒsummary±ÌµƒChildValue ˝æ›
 */
function getSummaryOfSummaryByChildValue(){
    var tag=0;
    var table=document.getElementsByTagName('table')[5];
    var rowsLength=table.rows.length;
    for(i=3;i<rowsLength;i++){
        if(table.rows[i].getAttribute("bgcolor")=="#BBffBB"){
            tag=i;
        }
    }
    var str='[';
    var table=document.getElementsByTagName('table')[5];
    var rowsLength=table.rows.length;
    for(i=3;i<rowsLength;i++){
        str+='{';
		str+='\"number\":\"'+table.rows[i].cells[0].innerText+'\",';
		str+='\"zone\":\"'+table.rows[i].cells[1].getElementsByTagName('img')[0].src+'\",';
		str+='\"currentFlow\":\"'+table.rows[i].cells[2].innerText+'\",';
		str+='\"averageFlow\":\"'+table.rows[i].cells[3].innerText+'\",';
		str+='\"Flow\":\"'+table.rows[i].cells[4].innerText+'\",';
		str+='\"zoneTimer\":\"'+table.rows[i].cells[5].getElementsByTagName('table')[1].width+'\",';
		str+='\"timer\":\"'+table.rows[i].cells[6].innerText+'\",';
        if(tag!=i){
            str+='\"errorCondition\":\"'+table.rows[i].cells[7].innerText.trim()+'\"';
        }else{
            str+='\"errorCondition\":\"error\"';
        }
		str+='}';
        if(i<rowsLength-1){
            str+=',';
        }
    }
    str+=']'
    return str;
}
/**
 *ªÒ»°manual.jsp“≥√Êµƒmanual±ÌµƒMasterValue ˝æ›
 */
function getManualOfManualByMasterValue(){
    var table=document.getElementsByTagName('table')[3];
    var str='{';
    str+='\"totalWaterUsed\"=\"'+table.rows[2].cells[1].innerText+'\";';
    str+='\"currentFlow\"=\"'+table.rows[2].cells[3].innerText+'\"';
    str+='}';
    return str;
}
/**
 *ªÒ»°manual.jsp“≥√Êµƒmanual±ÌµƒChildValue ˝æ›
 */
function getManualOfManualByChildValue(){
    var str='[';
    var table=document.getElementsByTagName('table')[3];
    var rowsLength=table.rows.length;
    for(i=5;i<rowsLength;i++){
        str+='{';
		str+='\"zone\"=\"'+table.rows[i].cells[1].getElementsByTagName('img')[0].src+'\";';
		str+='\"currentFlow\"=\"'+table.rows[i].cells[2].getElementsByTagName('input')[0].value+'\";';
		str+='\"waterUsed\"=\"'+table.rows[i].cells[3].getElementsByTagName('input')[0].value+'\"';
		str+='}';
        if(i<rowsLength-2){
            str+=',';
        }
    }
    str+=']'
    return str;
}
function getManual(){
    var str='[';
    var table=document.getElementsByTagName('table')[3];
    var rowsLength=table.rows.length;
    for(i=2;i<rowsLength;i++){
        str+='{';
		str+='\"number\":\"'+table.rows[i].cells[0].innerText+'\",';
		str+='\"zone\":\"'+table.rows[i].cells[1].getElementsByTagName('img')[0].src+'\",';
		str+='\"onOff\":\"'+table.rows[i].cells[2].getElementsByTagName('input')[0].value+'\",';
		str+='\"mistCont\":\"'+table.rows[i].cells[3].getElementsByTagName('input')[0].value+'\",';
		str+='\"zoneTimer1\":\"'+table.rows[i].cells[4].getElementsByTagName("table")[1].width+'\",';
		str+='\"zoneTimer2\":\"'+table.rows[i].cells[5].getElementsByTagName("input")[0].value+'\"';
		str+='}';
        if(i<rowsLength-1){
            str+=',';
        }
    }
    str+=']'
    return str;
}
/**
 *ªÒ»°auto.jsp“≥√Êµƒauto±Ìµƒ ˝æ›
 *
 */
function getAtuoOfByAuto(){
    var str='[';
    var table=document.getElementsByTagName('table')[7];
    var rowsLength=table.rows.length;
    for(i=2;i<rowsLength;i++){
        str+='{';
		str+='\"zone\":\"'+table.rows[i].cells[1].getElementsByTagName('img')[0].src+'\",';
		str+='\"onOff\":\"'+table.rows[i].cells[2].getElementsByTagName('input')[0].value+'\",';
		str+='\"mistCont\":\"'+table.rows[i].cells[3].getElementsByTagName('input')[0].value+'\",';
		str+='\"zoneTimer1\":\"'+table.rows[i].cells[4].getElementsByTagName("table")[1].width+'\",';
		str+='\"zoneTimer2\":\"'+table.rows[i].cells[5].getElementsByTagName("input")[0].value+'\"';
		str+='}';
        if(i<rowsLength-1){
            str+=',';
        }
    }
    str+=']'
    return str;
}
///////////////////////////////////////////////////
function getSummaryByConnected(){
    return document.getElementsByTagName("table")[2].rows[0].cells[6].innerText;
}
function getSummaryByProgramType(){
    return document.getElementsByTagName("table")[5].rows[0].cells[3].innerText
}
function getManualByConnect(){
    return document.getElementsByTagName("table")[2].rows[0].cells[6].innerText;
}
function getManualByRunningState(){
    return document.getElementsByTagName("table")[3].rows[0].cells[2].getElementsByTagName("input")[0].value;
}
function getAutoByProgram(){
    var str='';
    var table=document.getElementsByTagName('table')[5];
    var rowsLength=table.rows.length;
    for(i=0;i<rowsLength;i++){
		str+=table.rows[i].cells[0].innerText;
        if(i<rowsLength-1){
            str+=',';
        }
    }
    return str;
}
getAutoByProgram();
function getAutoByConnect(){
    return document.getElementsByTagName("table")[2].rows[0].cells[6].innerText;
}
function isChecked(obj){
    if(obj.checked){
        return true;
    }
    return false;
}
function getSetting(){
    var table=document.getElementsByTagName("table")[3];
    var str='{';
    str+='\"mistDutyCycle\":\"'+table.rows[3].cells[1].getElementsByTagName("input")[0].value+"%"+table.rows[3].cells[1].getElementsByTagName("input")[1].value+"sec"+'\",';
    str+='\"vacorPulseDCLatching\":\"'+(isChecked(document.getElementsByName("mode")[0])==true?document.getElementsByName("mode")[0].value:document.getElementsByName("mode")[1].value)+'\",';
    str+='\"flowRateTolerance\":\"'+table.rows[6].cells[1].getElementsByTagName("input")[0].value+"%"+'\",';
    str+='\"masterValveDelayTime\":\"'+table.rows[8].cells[1].innerText.trim()+'\",';
    str+='\"zoneDelayTime\":\"'+table.rows[9].cells[1].getElementsByTagName("input")[0].value+"min"+'\",';
    str+='\"flowSensorCalibration\":\"'+table.rows[10].cells[1].getElementsByTagName("input")[0].value+'\",';
    str+='\"input2\":\"'+(isChecked(document.getElementsByName("input2")[0])==true?document.getElementsByName("input2")[0].value:document.getElementsByName("input2")[1].value)+'\",';
    str+='\"input3\":\"'+(isChecked(document.getElementsByName("input3")[0])==true?document.getElementsByName("input3")[0].value:document.getElementsByName("input3")[1].value)+'\"';
    str+='}';
    return str;
    
}
function getAutoByProgramOne(){
    var table=document.getElementsByTagName("table")[6];
    var str='{';
    str+='\"ProgramName\":\"'+table.rows[1].cells[1].innerText+'\",';
    str+='\"startTime1\":\"'+table.rows[2].cells[1].getElementsByTagName("input")[0].value+'\",';
    str+='\"startTime2\":\"'+table.rows[2].cells[1].getElementsByTagName("input")[1].value+'\",';
    str+='\"wateringSchedule\":\"';
    var tags=table.rows[3].cells[1].getElementsByTagName("input");
    for(var tag in tags){
        str+=tags[tag].checked
        if(tag<=5){
            str+=',';
        }
        if(tag>=6){
            break;
        }
    }
    str+='\"';
    str+='}';
    return str;
}
function getSummarying(){
    var table=document.getElementsByTagName('table')[5];
    var rowsLength=table.rows.length;
    for(i=3;i<rowsLength;i++){
        if(table.rows[i].getAttribute("bgcolor")=="#BBffBB"){
            return table.rows[i].cells[0].innerText;
        }
    }
}getSummarying();

////////////////////////////2012-11-26 9:55////////////////////////////////////
function getSummaryingBytag(){
    var table=document.getElementsByTagName('table')[5];
    var rowsLength=table.rows.length;
    for(i=1;i<rowsLength;i++){
        if(table.rows[i].style.backgroundColor=="rgb(187, 255, 187)"){
            return i;
        }
    }
}
function geterror(){
    var tag=0;
    var table=document.getElementsByTagName('table')[5];
    var rowsLength=table.rows.length;
    for(i=3;i<rowsLength;i++){
        if(table.rows[i].getAttribute("bgcolor")=="#BBffBB"){
            tag=i;
        }
    }
    var str="";
    var table=document.getElementsByTagName('table')[5].rows[tag].cells[8].getElementsByTagName('table')[0];
    if(table.rows.length<4){
        return "Normal";
    }
    str+=table.rows[0].cells[0].innerText+",";
    str+=table.rows[1].cells[0].innerText+",";
    str+="All:"+table.rows[2].cells[1].getElementsByTagName("input")[0].value+":"+table.rows[2].cells[2].getElementsByTagName("input")[0].value+",";
    str+="Zone:"+table.rows[3].cells[1].getElementsByTagName("input")[0].value+":"+table.rows[3].cells[2].getElementsByTagName("input")[0].value+"";
    return str;
}




function getSettingFlowSensor(){
    var table=document.getElementsByTagName("table")[3];
    var cellsLength=table.rows[2].cells.length;
    var str="";
    for(i=1;i<cellsLength;i++){
        str+=	 table.rows[2].cells[i].getElementsByTagName("select")[0].options[table.rows[2].cells[i].getElementsByTagName("select")[0].selectedIndex].innerText+","
        
    }
	return str;
}getSettingFlowSensor();


function getAtuoOfByAuto2(i){
    var str='[';
    var table=document.getElementsByTagName('table')[7];
    return table.rows[i].cells[4].getElementsByTagName('table')[0].getAttribute("bordercolor")
}

document.getElementById("allWaterTextButton").style.backgroundColor


document.getElementById("timeM").options[document.getElementById("timeM").selectedIndex].value

function getbuttonColor(j){
    var button=document.getElementsByTagName('table')[5].rows[j].cells[7].getElementsByTagName('input');
    var str="";
    for(i=0;i<button.length;i++){
        str+=button[i].style.background+";";
    }
    return str;
}





//Weather

function getWeather(){
    var table=document.getElementsByTagName("table")[2];
    var rowsLength=table.rows.length;
    var str='{';
    for(i=1;i<rowsLength;i++){
        str+="\""+table.rows[i].cells[0].innerText+"\":\""+table.rows[i].cells[1].innerText+"\","
    }
    str=str.substring(0,str.length-1);
    str+='}';
    return str;
}
//------------------------
function getFunction(){
    return document.getElementById("isOpenButton").value.trim();
}
//------------
function getCityCode(){
    return document.getElementById("citySelect1").value;
}
//----------
function getStop(){
    return document.getElementById("tLow2Close").value;
}
//----------
function getStart(){
    return document.getElementById("tHigh2Open").value;
}
//----------
function getKeyAndValues(){
    var options=document.getElementById("rHigh2Close").options;
    var str="";
    for(i=0;i<options.length;i++){
        str+=options[i].value+":"+options[i].innerText+",";
    }
    return str;
}

