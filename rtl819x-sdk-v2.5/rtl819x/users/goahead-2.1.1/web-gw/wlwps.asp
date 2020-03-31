<html>
<! Copyright (c) Realtek Semiconductor Corp., 2007. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html">
<title>Wi-Fi Protected Setup</title>
<script type="text/javascript" src="util_gw.js"> </script>
<style>
.on {display:on}
.off {display:none}
</style>
<script>
<% val = getIndex("wlanMode");      
      if (val==1) 
	write ("var isClient=1;");     
      else
	write ("var isClient=0;"); %>
	
var isConfig=<% write(getIndex("wscConfig")); %>;
var wps_auth=<% write(getIndex("wps_auth")); %>;
var wps_enc=<% write(getIndex("wps_enc")); %>;
var wps_key="<%getInfo("wps_key");%>";

var encrypt=<% write(getIndex("encrypt"));%>; //ENCRYPT_DISABLED=0, ENCRYPT_WEP=1, ENCRYPT_WPA=2, ENCRYPT_WPA2=4, ENCRYPT_WPA2_MIXED=6 ,ENCRYPT_WAPI=7				
var enable1x=<% write(getIndex("enable1X"));%>;
var wpa_auth=<% write(getIndex("wpaAuth"));%>; //WPA_AUTH_AUTO=1, WPA_AUTH_PSK=2
var mode=<% write(getIndex("wlanMode"));%>; //AP_MODE=0, CLIENT_MODE=1, WDS_MODE=2, AP_WDS_MODE=3, AP_MPP_MODE=4, MPP_MODE=5, MAP_MODE=6, MP_MODE=7
var is_adhoc=<% write(getIndex("networkType"));%>; //INFRASTRUCTURE=0, ADHOC=1


var is_rpt=<% write(getIndex("repeaterEnabled"));%>;
var is_rpt_wps_support=<% write(getIndex("is_rpt_wps_support"));%>;

var isRptConfig=<% write(getIndex("wscRptConfig")); %>;
var wpsRpt_auth=<% write(getIndex("wpsRpt_auth")); %>;
var wpsRpt_enc=<% write(getIndex("wpsRpt_enc")); %>;
var wpsRpt_key="<%getInfo("wpsRpt_key");%>";

var encrypt_rpt=<% write(getIndex("encrypt_rpt"));%>; //ENCRYPT_DISABLED=0, ENCRYPT_WEP=1, ENCRYPT_WPA=2, ENCRYPT_WPA2=4, ENCRYPT_WPA2_MIXED=6 ,ENCRYPT_WAPI=7				
var enable1x_rpt=<% write(getIndex("enable1x_rpt"));%>;
var wpa_auth_rpt=<% write(getIndex("wpa_auth_rpt"));%>; //WPA_AUTH_AUTO=1, WPA_AUTH_PSK=2
var mode_rpt=<% write(getIndex("wlanMode_rpt"));%>; //AP_MODE=0, CLIENT_MODE=1, WDS_MODE=2, AP_WDS_MODE=3, AP_MPP_MODE=4, MPP_MODE=5, MAP_MODE=6, MP_MODE=7
var is_adhoc_rpt=<% write(getIndex("networkType_rpt"));%>; //INFRASTRUCTURE=0, ADHOC=1


var warn_msg1='WPS was disabled automatically because wireless mode setting could not be supported. ' +
				'You need go to Wireless/Basic page to modify settings to enable WPS.';
var warn_msg2='WPS was disabled automatically because Radius Authentication could not be supported. ' +
				'You need go to Wireless/Security page to modify settings to enable WPS.';
var warn_msg3="PIN number was generated. You have to click \'Apply Changes\' button to make change effectively.";
var disable_all=0;
var disable_rpt_all=0;

function triggerPBCClicked()
{
  	return true;
}

function triggerPINClicked()
{
	return(saveChangesWPS(document.formWsc));	
}

function resetUnCfgClicked()
{
	document.formWsc.elements["resetUnCfg"].value = 1;
	document.forms["formWsc"].submit();	
}

function resetRptUnCfgClicked()
{
	document.formWsc.elements["resetRptUnCfg"].value = 1;
	document.forms["formWsc"].submit();	
}

function compute_pin_checksum(val)
{
	var accum = 0;	
	var code = parseInt(val)*10;

	accum += 3 * (parseInt(code / 10000000) % 10); 
	accum += 1 * (parseInt(code / 1000000) % 10); 
	accum += 3 * (parseInt(code / 100000) % 10); 
	accum += 1 * (parseInt(code / 10000) % 10);
	accum += 3 * (parseInt(code / 1000) % 10);
	accum += 1 * (parseInt(code / 100) % 10);
	accum += 3 * (parseInt(code / 10) % 10); 
	accum += 1 * (parseInt(code / 1) % 10);	
	var digit = (parseInt(accum) % 10);
	return ((10 - digit) % 10);
}

/*
function genPinClicked()
{
	var num_str="1";
	var rand_no;
	var num;

	while (num_str.length != 7) {
		rand_no = Math.random()*1000000000;	
		num = parseInt(rand_no, 10);
		num = num%10000000;
		num_str = num.toString();
	}
	
	num = num*10 + compute_pin_checksum(num);
	num = parseInt(num, 10);	
	document.formWsc.elements["localPin"].value = num; 
	alert(warn_msg3);
}
*/
function validate_pin_code(code)
{
	var accum=0;

	accum += 3 * (parseInt(code / 10000000) % 10); 
	accum += 1 * (parseInt(code / 1000000) % 10); 
	accum += 3 * (parseInt(code / 100000) % 10); 
	accum += 1 * (parseInt(code / 10000) % 10);
	accum += 3 * (parseInt(code / 1000) % 10);
	accum += 1 * (parseInt(code / 100) % 10);
	accum += 3 * (parseInt(code / 10) % 10); 
	accum += 1 * (parseInt(code / 1) % 10);
	return (0 == (accum % 10));	
}


// modify for WPS2DOTX  test case 4.2.4  ; PIN input can filter whitespace and dash
function check_pin_code(str)
{
	var i;
	var code_len;		
	code_len = str.length;

	var codestr="";		

	for (i=0; i<str.length; i++) {

		if ((str.charAt(i) == ' ') || (str.charAt(i) == '-')){
			code_len --;
			continue ;
		}else{
			codestr += str.charAt(i);
		}
					
		if ((str.charAt(i) < '0') || (str.charAt(i) > '9'))
			return 2;
			
	}
	

	
	if (code_len != 8 && code_len != 4)
		return 1;
		
	if (code_len == 8) {
		var code = parseInt(codestr, 10);
		if (!validate_pin_code(code))
			return 3;
		else
			return 0;
	}
	else
		return 0;
}
// modify for WPS2DOTX  test case 4.2.4  ; PIN input can filter whitespace and dash

function setPinClicked(peerPingObj)
{
	var ret;
	ret = check_pin_code(peerPingObj.value);
	if (ret == 1) {
		alert('Invalid Enrollee PIN length! The device PIN is usually four or eight digits long.');
		form.peerPin.focus();		
		return false;
	}
	else if (ret == 2) {
		alert('Invalid Enrollee PIN! Enrollee PIN must be numeric digits.');
		form.peerPin.focus();		
		return false;
	}
	else if (ret == 3) {
		if ( !confirm('Checksum failed! Use PIN anyway? ') ) {
			form.peerPin.focus();
			return false;
  		}
	}	
	return true;
}


function checkWPSstate(form, isClientChk, isRptChk)
{
	if (disable_all) {
		disableCheckBox(form.elements["disableWPS"]);
		disableButton(form.elements["save"]);
		disableButton(form.elements["reset"]);  
	}
	if(isClientChk)
	{
		if (disable_all || form.elements["disableWPS"].checked) {	 	
	 		//disableTextField(form.elements["localPin"]);	 	
			disableTextField(form.elements["peerPin"]);
			disableButton(form.elements["setPIN"]);
			disableButton(form.elements["triggerPIN"]);	 	
			disableButton(form.elements["triggerPBC"]);
			//disableButton(form.elements["genPIN"]); 
			disableButton(form.elements["resetUnConfiguredBtn"]);
			
		}
		else {
			//enableTextField(form.elements["localPin"]);
			enableTextField(form.elements["peerPin"]);
			enableButton(form.elements["setPIN"]);
			//enableButton(form.elements["genPIN"]);
			enableButton(form.elements["triggerPIN"]);		
			enableButton(form.elements["triggerPBC"]);
			
			if (isConfig==1)
				enableButton(form.elements['resetUnConfiguredBtn']);
			else
				disableButton(form.elements['resetUnConfiguredBtn']);
					
		}
	}
		
	/*
	if (disable_rpt_all) {
		disableCheckBox(form.elements["disableWPS"]);
		disableButton(form.elements["save"]);
		disableButton(form.elements["reset"]);  
	}
	*/
	if(isClient == 1 && isRptChk)
	{
		if (disable_rpt_all || form.elements["disableWPS"].checked) 
		{
			//disableTextField(form.elements["localPin"]);	 	
			disableTextField(form.elements["peerRptPin"]);
			disableButton(form.elements["setRptPIN"]);
			disableButton(form.elements["triggerRptPIN"]);	 	
			disableButton(form.elements["triggerRptPBC"]);
			//disableButton(form.elements["genPIN"]); 
			disableButton(form.elements["resetRptUnConfiguredBtn"]);
			
		}
		else 
		{
			//enableTextField(form.elements["localPin"]);
			enableTextField(form.elements["peerRptPin"]);
			enableButton(form.elements["setRptPIN"]);
			//enableButton(form.elements["genPIN"]);
			enableButton(form.elements["triggerRptPIN"]);		
			enableButton(form.elements["triggerRptPBC"]);
	     
			if (isRptConfig==1) 
				enableButton(form.elements['resetRptUnConfiguredBtn']);
			else
				disableButton(form.elements['resetRptUnConfiguredBtn']);

		
		
		}
		
		disableRadioGroup(form.elements["configVxd"]);
	}
	disableRadioGroup(form.elements["config"]);
	

	
	
	

	return true;
}

function saveChangesWPS(form)
{
/*	
	ret = check_pin_code(form.elements["localPin"].value);
	if (ret == 1) {
		alert('Invalid PIN length! The device PIN is usually four or eight digits long.');
		form.localPin.focus();
		return false;
	}
	else if (ret == 2) {
		alert('Invalid PIN! The device PIN must be numeric digits.');
		form.localPin.focus();		
		return false;
	}
	else if (ret == 3) {
		alert('Invalid PIN! Checksum error.');
		form.localPin.focus();		
		return false;
	}
*/  	
   	return true;
}

function Load_Setting()
{
	if(is_rpt == 1 && is_rpt_wps_support == 1 && isClient == 1)
		show_div(true,("repeater_hide_div"));	
	else
		show_div(false,("repeater_hide_div"));	
	
	if(isConfig == 1)
		document.formWsc.elements["config"][0].checked = true;
	else
		document.formWsc.elements["config"][1].checked = true;

		

}
</script>
</head>

<body onload="Load_Setting();">
<blockquote>
<h2><font color="#0000FF">Wi-Fi Protected Setup</font></h2>

<form action=/goform/formWsc method=POST name="formWsc">
<table border=0 width="500" cellspacing=4 cellpadding=0>
<tr><font size=2>
 This page allows you to change the setting for WPS (Wi-Fi Protected Setup). Using 
 this feature could let your wireless client automically syncronize its setting and 
 connect to the Access Point in a minute without any hassle.
</font></tr>
<script>
	if (mode == 0 || mode == 3) //0:AP 3:AP+WDS
	    disable_all = check_wps_enc(encrypt, enable1x, wpa_auth);
	else
		disable_all = check_wps_wlanmode(mode, is_adhoc);
		
		var isRptClient = !isClient;  
	if (mode_rpt == 0 || mode_rpt == 3) //0:AP 3:AP+WDS
	    disable_rpt_all = check_wps_enc(encrypt_rpt, enable1x_rpt, wpa_auth_rpt);
	else
		disable_rpt_all = check_wps_wlanmode(mode_rpt, is_adhoc_rpt);
</script>
<tr>
  <td width="100%" colspan=3><font size=4><b>
   	<input type="checkbox" name="disableWPS" value="ON" <% if (getIndex("wscDisable")) write("checked");%>  ONCLICK="checkWPSstate(document.formWsc, 1, 1)">&nbsp;&nbsp;Disable WPS
  </td>
</tr>
<input type="hidden" value="/wlwps.asp" name="submit-url">
<tr>
   <td width="100%" colspan="2"  height=40><input type="submit" value="Apply Changes" name="save" onClick="return saveChangesWPS(document.formWsc)">&nbsp;&nbsp;
		<input type="reset" value="Reset" name="reset"></td>
</tr>
<tr><hr size=1 noshade align=top></tr>
<script>
	if(is_rpt)
	{
  	if (isClient)
			document.write("<td width='40%'><font size='4'><b>-Repeater Client-</b></font></td>");
		//else
			//document.write("<td width='40%'><font size='4'><b>-Repeater AP-</b></font></td>");
			
		document.write("<td width='60%'></td>");
	}	
</script>
<script>
  if (isClient) {
	document.write("</table>\n");
	document.write("<span id = \"hide_div\" class = \"off\">\n");
	document.write("<table border=\"0\" width=500>\n");
  }
</script>
<tr>
  <td width="40%"><font size="2"><b>WPS Status:</b></font></td>  
  <td width="60%"><font size="2">
	  <input type="radio" name="config" value="on" >Configured&nbsp;&nbsp;
	  <input type="radio" name="config" value="off">UnConfigured
	</font></td>  
</tr>
<tr>
  <td width="40%"><font size="2"><b>&nbsp;</b></font></td> 
  <td width="60%"><font size="2">
  	<input type="hidden" value="0" name="resetUnCfg">
  	<input type="button" value="Reset to UnConfigured" name="resetUnConfiguredBtn" onClick="return resetUnCfgClicked()"></td>
	</font></td>  
</tr>
<script>
  if (isClient) {
	document.write("</table>\n");
	document.write("</span>\n");
	document.write("<table border=\"0\" width=500>\n");
  }
</script>
<tr>
  <td width="40%"><font size="2"><b>Self-PIN Number:</b></font></td>
  <td width="60%"><font size="2"><% getInfo("wscLoocalPin");%></td>
</tr>

<script>
  if (!isClient) {
	document.write("</table>\n");
	document.write("<span id = \"hide_div\" class = \"off\">\n");
	document.write("<table border=\"0\" width=500>\n");
  }
</script>
<tr>
  <td width="40%"><font size="2"><b>PIN Configuration:</b></font></td> 
  <td width="60%"><font size="2">
<!--WPS2DOTX for client mode improved --> 
    <b>Special Target AP MAC:</b>
    <input type="text" name="targetAPMac" size="12" maxlength="17" value="">
    <b>Special Target AP SSID:</b>
    <input type="text" name="targetAPSsid" size="20" maxlength="33" value="">		
<!--WPS2DOTX for client mode improved --> 
  	<input type="submit" value="Start PIN" name="triggerPIN" onClick="return triggerPINClicked()"></td>
	</font></td>  
</tr>
<script>
  if (!isClient) {
	document.write("</table>\n");
	document.write("</span>\n");
	document.write("<table border=\"0\" width=500>\n");
  }
</script>

<tr>
  <td width="40%"><font size="2"><b>Push Button Configuration:</b></font></td> 
  <td width="60%"><font size="2">
  	<input type="submit" value="Start PBC" name="triggerPBC" onClick="return triggerPBCClicked()"></td>
	</font></td>  
</tr>
<!--WPS2DOTX for client mode improved --> 
<tr>
  <td width="40%"><font size="2"><b>STOP WSC</b></font></td> 
  <td width="60%"><font size="2">
  	<input type="submit" value="Stop WSC" name="stopwsc" onClick=""></td>
	</font></td>  
</tr>
<!--WPS2DOTX for client mode improved --> 


 <script>
if (isClient)
	document.write("<span id = \"hide_div\" class = \"off\">\n");
</script>

<table border='0' width="500">
<tr>
  <td width="40%"><font size="2"><b>Client PIN Number:</b></font></td>
  <td width="60%"><font size="2"><input type="text" name="peerPin" size="12" maxlength="10" value="">
  	&nbsp;&nbsp;<input type="submit" value="Start PIN" name="setPIN" onClick="return setPinClicked(document.formWsc.peerPin)"></td>
</tr>
</table>
<script>
  if (isClient)
	document.write("</span>\n");
   checkWPSstate(document.formWsc, 1, 0);
</script>



 <script>
 	if (disable_all) {
		 document.write("<tr><td colspan=\"2\" height=\"55\"><font size=2><em>");
	   	if (disable_all == 1)     
   			document.write(warn_msg1);
	   	else
	   		document.write(warn_msg2);
		document.write("</td></tr>"); 	   	
 	}
</script>  
 	
<script>
	if (isClient || !isConfig)
		document.write("<span id = \"hide_div\" class = \"off\">\n");
</script>
<table border='0' width="500">
<tr><td><font size=2><b>Current Key Info:</b></td></tr>
<table border='1' width="500">
<tr bgcolor=#7f7f7f>
   <td width="30%"><font size=2><b>Authentication</b></td>
   <td width="20%"><font size=2><b>Encryption</b></td>
   <td width="50%"><font size=2><b>Key</b></td>
</tr>

<tr>
   <td width="30%"><font size=2>
     
<SCRIPT>      
      if ( wps_auth == 1 )
      	 document.write("Open");
      else if ( wps_auth == 2 )
      	 document.write("WPA PSK");
      else if ( wps_auth == 4 )
      	 document.write("WEP Shared");
      else if ( wps_auth == 8 )
      	 document.write("WPA Enterprise");
      else if ( wps_auth == 16 )
      	 document.write("WPA2 Enterprise");
      else if ( wps_auth == 32 )
      	 document.write("WPA2 PSK");
      else if ( wps_auth == 34 )
      	 document.write("WPA2-Mixed PSK");       
</SCRIPT>      
   </td>
   <td width="20%"><font size=2>
<SCRIPT>   	
     
      if (wps_enc== 0 || wps_enc == 1)
      	 document.write("None");     
      if (wps_enc == 2)
      	document.write("WEP");
      if (wps_enc == 4)
      	document.write("TKIP");
      if (wps_enc == 8)
      	document.write("AES");      	 
      if (wps_enc == 12)
      	document.write("TKIP+AES"); 
</SCRIPT>      
   </td>
   <td width="50%"><font size=2>
<SCRIPT>   	
     document.write(wps_key); 
</SCRIPT>
   </td>
</tr>
</table><br></table>

<script>
  if (isClient || !isConfig)
	document.write("</span>\n");
</script>
  


<!-- Repeater Div -->
<span id = "repeater_hide_div" class = "off">
<table border=0 width="500" cellspacing=4 cellpadding=0>
<tr><hr size=1 noshade align=top></tr>
<script>
	
  if (isRptClient)
		document.write("<td width='40%' colspan=2><font size='4'><b>-Repeater Client-</b></font></td>");
	else
		document.write("<td width='40%' colspan=2><font size='4'><b>-Repeater AP-</b></font></td>");
	
</script>
<script>
  if (isRptClient) {
	document.write("</table>\n");
	document.write("<span id = \"hide_div\" class = \"off\">\n");
	document.write("<table border=\"0\" width=500>\n");
      }      
</script>
<tr>
  <td width="40%"><font size="2"><b>WPS Status:</b></font></td>  
  <td width="60%"><font size="2">
	  <input type="radio" name="configVxd" value="on" <% if (getIndex("wscRptConfig")) write("checked"); %>>Configured&nbsp;&nbsp;
	  <input type="radio" name="configVxd" value="off" <% if (!getIndex("wscRptConfig")) write("checked"); %>>UnConfigured
	</font></td>  
</tr>
<tr>
  <td width="40%"><font size="2"><b>&nbsp;</b></font></td> 
  <td width="60%"><font size="2">
  	<input type="hidden" value="0" name="resetRptUnCfg">
  	<input type="button" value="Reset to UnConfigured" name="resetRptUnConfiguredBtn" onClick="return resetRptUnCfgClicked()"></td>
	</font></td>  
</tr>
<script>
  if (isRptClient) {
	document.write("</table>\n");
	document.write("</span>\n");
	document.write("<table border=\"0\" width=500>\n");
	  }
</script>

<tr>
	<!--
  <td width="40%"><font size="2"><b>Self-PIN Number:</b></font></td>
  <td width="60%"><font size="2"><% getInfo("wscLoocalPin");%></td>
  -->
</tr>

<script>
  if (!isRptClient) {
	document.write("</table>\n");
	document.write("<span id = \"hide_div\" class = \"off\">\n");
	document.write("<table border=\"0\" width=500>\n");
	  }
</script>
<tr>
  <td width="40%"><font size="2"><b>PIN Configuration:</b></font></td> 
  <td width="60%"><font size="2">
  	<input type="submit" value="Start PIN" name="triggerRptPIN" onClick="return triggerPINClicked()"></td>
	</font></td>  
</tr>
<script>
  if (!isRptClient) {
	document.write("</table>\n");
	document.write("</span>\n");
	document.write("<table border=\"0\" width=500>\n");
  }      
</script>

<tr>
  <td width="40%"><font size="2"><b>Push Button Configuration:</b></font></td> 
  <td width="60%"><font size="2">
  	<input type="submit" value="Start PBC" name="triggerRptPBC" onClick="return triggerPBCClicked()"></td>
	</font></td>  
</tr>



 <script>
if (isRptClient)
	document.write("<span id = \"hide_div\" class = \"off\">\n");
</script>

<table border='0' width="500">
<tr>
  <td width="40%"><font size="2"><b>Client PIN Number:</b></font></td>
  <td width="60%"><font size="2"><input type="text" name="peerRptPin" size="12" maxlength="10" value="">
  	&nbsp;&nbsp;<input type="submit" value="Start PIN" name="setRptPIN" onClick="return setPinClicked(document.formWsc.peerRptPin)"></td>
</tr>
</table>
<script>
  if (isRptClient)
	document.write("</span>\n");
   checkWPSstate(document.formWsc, 0, 1);
</script>
  


 <script>
 	if (disable_all) {
		 document.write("<tr><td colspan=\"2\" height=\"55\"><font size=2><em>");
	   	if (disable_all == 1)     
   			document.write(warn_msg1);
	   	else
	   		document.write(warn_msg2);
		document.write("</td></tr>"); 	   	
 	}
</script>   	

<script>
   		
	if (isRptClient || !isRptConfig)
		document.write("<span id = \"hide_div\" class = \"off\">\n");
</script>
<table border='0' width="500">
<tr><td><font size=2><b>Current Key Info:</b></td></tr>
<table border='1' width="500">
<tr bgcolor=#7f7f7f>
   <td width="30%"><font size=2><b>Authentication</b></td>
   <td width="20%"><font size=2><b>Encryption</b></td>
   <td width="50%"><font size=2><b>Key</b></td>
</tr>

<tr>
   <td width="30%"><font size=2>
     <SCRIPT>      
      if ( wpsRpt_auth == 1 )
      	 document.write("Open");
      else if ( wpsRpt_auth == 2 )
      	 document.write("WPA PSK");
      else if ( wpsRpt_auth == 4 )
      	 document.write("WEP Shared");
      else if ( wpsRpt_auth == 8 )
      	 document.write("WPA Enterprise");
      else if ( wpsRpt_auth == 16 )
      	 document.write("WPA2 Enterprise");
      else if ( wpsRpt_auth == 32 )
      	 document.write("WPA2 PSK");
      else if ( wpsRpt_auth == 34 )
      	 document.write("WPA2-Mixed PSK");       
</SCRIPT> 
	 </td>
   <td width="20%"><font size=2>
<SCRIPT>   	     
      if (wpsRpt_enc== 0 || wpsRpt_enc == 1)
      	 document.write("None");     
      else if (wpsRpt_enc == 2)
      	document.write("WEP");
      else if (wpsRpt_enc == 4)
      	document.write("TKIP");
      else if (wpsRpt_enc == 8)
      	document.write("AES");      	 
      else if (wpsRpt_enc == 12)
      	document.write("TKIP+AES"); 
</SCRIPT> 
	 </td>
   <td width="50%"><font size=2>
<SCRIPT>   	
     document.write(wpsRpt_key); 
</SCRIPT>
   </td>
</tr>
</table><br></table>

<script>
  if (isRptClient || !isRptConfig)
	document.write("</span>\n");
</script>

</span>
	
<table width="500">
<hr>
</table>
	
</form>
</blockquote>
</body>

</html>