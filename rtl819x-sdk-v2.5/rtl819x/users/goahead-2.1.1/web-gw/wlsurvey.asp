<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html">
<title>Wireless Site Survey</title>
<script type="text/javascript" src="util_gw.js"> </script>
<style>
.on {display:on}
.off {display:none}
</style>
<script>
var wlan_idx= <% write(getIndex("wlan_idx")); %>*1 ;	
var siteSurveyForm=document.wizardPocket;	
var wlanMode = <% write(getIndex("wlanMode")); %>*1;
var wlanBand = "<% getInfo('wlanband'); %>" *1;



// For 802.1x client mode
var client_mode_support_1x=<% write(getIndex("clientModeSupport1X"));%>;
//var ap_mode=1;	// always client mode go here


// For wapi client mode (only psk now)
var client_mode_support_wapi=<% write(getIndex("clientModeSupportWapi"));%>;


var getFFVersion=navigator.userAgent.substring(navigator.userAgent.indexOf("Firefox")).split("/")[1]
//extra height in px to add to iframe in FireFox 1.0+ browsers
var FFextraHeight=getFFVersion>=0.1? 16 : 0 
function dyniframesize() {
	var iframename ="SSIDSiteSurvey";
  var pTar = null;
  if (document.getElementById){
    pTar = document.getElementById(iframename);
  }
  else{
    eval('pTar = ' + iframename + ';');
  }
  if (pTar && !window.opera){
    //begin resizing iframe
    pTar.style.display="block"
    
    if (pTar.contentDocument && pTar.contentDocument.body.offsetHeight){
      //ns6 syntax
      pTar.height = pTar.contentDocument.body.offsetHeight+FFextraHeight; 
    }
    else if (pTar.Document && pTar.Document.body.scrollHeight){
      //ie5+ syntax
      pTar.height = pTar.Document.body.scrollHeight;
    }
  }
}



function change_1x_eap_type_settings()
{
	var index;
	var insideIndex;

	index=document.wizardPocket.elements["eapType"+wlan_idx].selectedIndex;
	if(index ==0){//eap-md5
		disableTextField(document.wizardPocket.elements["eapInsideType"+wlan_idx]);	
		enableTextField(document.wizardPocket.elements["eapUserId"+wlan_idx]);
		enableTextField(document.wizardPocket.elements["radiusUserName"+wlan_idx]);
		enableTextField(document.wizardPocket.elements["radiusUserPass"+wlan_idx]);
		disableTextField(document.wizardPocket.elements["radiusUserCertPass"+wlan_idx]);
	}
	else if(index ==1){//eap-tls
		disableTextField(document.wizardPocket.elements["eapInsideType"+wlan_idx]);	
		enableTextField(document.wizardPocket.elements["eapUserId"+wlan_idx]);
		disableTextField(document.wizardPocket.elements["radiusUserName"+wlan_idx]);
		disableTextField(document.wizardPocket.elements["radiusUserPass"+wlan_idx]);
		enableTextField(document.wizardPocket.elements["radiusUserCertPass"+wlan_idx]);
	}
	else if(index ==2){//eap-peap
		enableTextField(document.wizardPocket.elements["eapInsideType"+wlan_idx]);
		enableTextField(document.wizardPocket.elements["eapUserId"+wlan_idx]);
		
		insideIndex=document.wizardPocket.elements["eapInsideType"+wlan_idx].selectedIndex;
		if(insideIndex==0){//eap-peap-mschapv2
			enableTextField(document.wizardPocket.elements["radiusUserName"+wlan_idx]);
			enableTextField(document.wizardPocket.elements["radiusUserPass"+wlan_idx]);
			enableTextField(document.wizardPocket.elements["radiusUserCertPass"+wlan_idx]);
		}
		else{//to add more.
			alert("This inside type is not supported.");
		}
	}
	else{//to add more.
		alert("This EAP type is not supported.");
	}
}

function show_wpa_settings()
{
	var dF=document.forms[0];
//	var wep_type = get_by_id("method");
	var allow_tkip=0;
//	var wlan_index=<% write(getIndex("wlan_idx")); %>;
	var sleIndex=get_by_id("method"+wlan_idx).selectedIndex;
	
	if(sleIndex==2 || sleIndex==3)
		allow_tkip=0;
	else
		allow_tkip=1;
	
	get_by_id("show_wpa_psk1").style.display = "none";
	get_by_id("show_wpa_psk2").style.display = "none";	
//	get_by_id("show_8021x_eap").style.display = "none";
//	get_by_id("show_8021x_eap_client").style.display = "none";
	show_div(false, "show_8021x_eap_client");
//	get_by_id("show_pre_auth").style.display = "none";
	
	if (dF.wpaAuth<% write(getIndex("wlan_idx")); %>[1].checked)
	{
		get_by_id("show_wpa_psk1").style.display = "";
		get_by_id("show_wpa_psk2").style.display = "";		
	}
	else{
//		if(ap_mode != 1){
//			get_by_id("show_8021x_eap").style.display = "";
//		}
//		else{
			if(client_mode_support_1x == 1){
				//get_by_id("show_8021x_eap_client").style.display = "";
				show_div(true, "show_8021x_eap_client");
				change_1x_eap_type_settings();
			}
//		}
	}
	
//		if("<% getInfo('wlan_onoff_tkip'); %>" * 1 == 0)
//		{
//			if(wlanMode!=1 && (wlanBand == 8 || wlanBand == 10 || wlanBand == 11) && allow_tkip==0)
//			{
//				dF.ciphersuite<% write(getIndex("wlan_idx")); %>[0].checked=false;
//				dF.ciphersuite<% write(getIndex("wlan_idx")); %>[0].disabled=true;
				
//				dF.wpa2ciphersuite<% write(getIndex("wlan_idx")); %>[0].checked=false;
//				dF.wpa2ciphersuite<% write(getIndex("wlan_idx")); %>[0].disabled=true;
				
//			}
//			else
//			{
//				dF.ciphersuite<% write(getIndex("wlan_idx")); %>[0].disabled=false;
//				dF.wpa2ciphersuite<% write(getIndex("wlan_idx")); %>[0].disabled=false;
//			}
//		}
	
}




function show_wapi_settings()
{
        var dF=document.forms[0];
        var wep_type = get_by_id("method");
        
	  get_by_id("show_wapi_psk1").style.display = "none";
	  get_by_id("show_wapi_psk2").style.display = "none";
//        get_by_id("show_8021x_wapi").style.display = "none";
	  show_div(false,("show_8021x_wapi"));	
//      get_by_id("show_pre_auth").style.display = "none";
        
        if (dF.wapiAuth<% write(getIndex("wlan_idx")); %>[1].checked){
                get_by_id("show_wapi_psk1").style.display = "";
                get_by_id("show_wapi_psk2").style.display = "";
        }
        else{
//                if (ap_mode != 1)
//                {
//				show_div(true,("show_8021x_wapi"));	
//			if('<% getInfo("wapiLocalAsSupport");%>'=='true')
//			{
//				get_by_id("show_8021x_wapi_local_as").style.display = "";
//			}
//			else
//			{
//				get_by_id("show_8021x_wapi_local_as").style.display = "none";
//				dF.uselocalAS<% write(getIndex("wlan_idx")); %>.checked=false;
//			}
//                }
		    if (dF.wapiASIP<% write(getIndex("wlan_idx")); %>.value == "<% getInfo("ip-rom"); %>")
		    {
				dF.uselocalAS<% write(getIndex("wlan_idx")); %>.checked=true;
		    }
//              if (wep_type.selectedIndex > 2) 
//                      get_by_id("show_pre_auth").style.display = "";          
        }
}

function show_wapi_ASip()
{
	var dF=document.forms[0];
	if (dF.uselocalAS<% write(getIndex("wlan_idx")); %>.checked)
	{
		dF.wapiASIP<% write(getIndex("wlan_idx")); %>.value = "<% getInfo("ip-rom"); %>";
        }
	else
	{
		dF.wapiASIP<% write(getIndex("wlan_idx")); %>.value = "";
	}
}




function wizardHideDiv()
{

	show_div(false, "top_div");
	
	show_div(false, "wlan_security_div");
	show_div(false, "wep_div");
	show_div(false, "wpa_div");
	show_div(false, "show_8021x_eap_client");
	show_div(false, "wait_div");

	//if(client_mode_support_wapi==1){
		show_div(false,("setting_wapi"));
		show_div(false,("show_8021x_wapi"));
	//}
}
  
function pocket_checkState(wlanIdx)
{
	var wizardForm=document.wizard;
	var pocketForm=document.wizardPocket;
	var dF=document.forms[0];

  get_by_id("show_wpa_cipher").style.display = "none";
  get_by_id("show_wpa2_cipher").style.display = "none";
	
  if(get_by_id("method"+wlanIdx).selectedIndex == 0){ //none
  		show_div(false,("wpa_div"));	
		show_div(false, "show_8021x_eap_client");
  		show_div(false,("wep_div"));	
  }
  else if(get_by_id("method"+wlanIdx).selectedIndex == 1){ //wep
  		show_div(false,("wpa_div"));	
		show_div(false, "show_8021x_eap_client");
  		show_div(true,("wep_div"));	
  }
  else if((get_by_id("method"+wlanIdx).selectedIndex == 2) || (get_by_id("method"+wlanIdx).selectedIndex == 3)){ //wpa/wpa2
  		show_div(true,("wpa_div"));	
		if(get_by_id("method"+wlanIdx).selectedIndex == 2){//wpa
			get_by_id("show_wpa_cipher").style.display = "";
			get_by_id("show_wpa2_cipher").style.display = "none";
		}
		else if(get_by_id("method"+wlanIdx).selectedIndex == 3){//wpa2
			get_by_id("show_wpa_cipher").style.display = "none";
			get_by_id("show_wpa2_cipher").style.display = "";
		}
		else{
			alert("wrong method!");//Added for test
		}
		show_wpa_settings();
		
  		show_div(false,("wep_div"));	
  }
  else if((client_mode_support_wapi)&&(get_by_id("method"+wlanIdx).selectedIndex == 4)){	//wapi
  	show_div(true,("setting_wapi"));
	show_div(true,("show_8021x_wapi"));	

	//Patch: only wapi-psk supported now for wireless client mode
	dF.wapiAuth<% write(getIndex("wlan_idx")); %>[0].checked=false;
	dF.wapiAuth<% write(getIndex("wlan_idx")); %>[0].disabled=true;
	dF.wapiAuth<% write(getIndex("wlan_idx")); %>[1].checked=true;
	show_wapi_settings();
  }
  else{
  	alert("Error: not supported method id "+get_by_id("method"+wlanIdx).selectedIndex);
  }

}
  
function saveClickSSID()
{		
	var dF=document.forms[0];
	
	wizardHideDiv();
	show_div(true, ("wlan_security_div"));														

	if(document.getElementById("pocket_encrypt").value == "no")
		get_by_id("method"+wlan_idx).selectedIndex = 0;
	else if(document.getElementById("pocket_encrypt").value == "WEP")
		get_by_id("method"+wlan_idx).selectedIndex = 1;
	else if(document.getElementById("pocket_encrypt").value.indexOf("WPA2") != -1){
		get_by_id("method"+wlan_idx).selectedIndex = 3;

		if((client_mode_support_1x==1)&&(document.getElementById("pocket_encrypt").value.indexOf("-1X") !=-1)){
			dF.wpaAuth<% write(getIndex("wlan_idx")); %>[0].checked=true;
			dF.wpaAuth<% write(getIndex("wlan_idx")); %>[1].checked=false;
		}
		else{
			dF.wpaAuth<% write(getIndex("wlan_idx")); %>[0].checked=false;
			dF.wpaAuth<% write(getIndex("wlan_idx")); %>[1].checked=true;
		}

		if(document.getElementById("pocket_wpa2_tkip_aes").value.indexOf("aes")!=-1){
			dF.wpa2ciphersuite<% write(getIndex("wlan_idx")); %>[0].checked=false;
			dF.wpa2ciphersuite<% write(getIndex("wlan_idx")); %>[1].checked=true;
		}
		else if(document.getElementById("pocket_wpa2_tkip_aes").value.indexOf("tkip")!=-1){
			dF.wpa2ciphersuite<% write(getIndex("wlan_idx")); %>[0].checked=true;
			dF.wpa2ciphersuite<% write(getIndex("wlan_idx")); %>[1].checked=false;
		}
		else{
			alert("Error: not supported wpa2 cipher suite "+document.getElementById("pocket_wpa2_tkip_aes").value);//Added for test
		}
	}
	else if(document.getElementById("pocket_encrypt").value.indexOf("WPA") != -1){
		get_by_id("method"+wlan_idx).selectedIndex = 2;
		if((client_mode_support_1x==1)&&(document.getElementById("pocket_encrypt").value.indexOf("-1X") !=-1)){
			dF.wpaAuth<% write(getIndex("wlan_idx")); %>[0].checked=true;
			dF.wpaAuth<% write(getIndex("wlan_idx")); %>[1].checked=false;
		}
		else{
			dF.wpaAuth<% write(getIndex("wlan_idx")); %>[0].checked=false;
			dF.wpaAuth<% write(getIndex("wlan_idx")); %>[1].checked=true;
		}

		if(document.getElementById("pocket_wpa_tkip_aes").value.indexOf("aes")!=-1){
			dF.ciphersuite<% write(getIndex("wlan_idx")); %>[0].checked=false;
			dF.ciphersuite<% write(getIndex("wlan_idx")); %>[1].checked=true;
		}
		else if(document.getElementById("pocket_wpa_tkip_aes").value.indexOf("tkip")!=-1){
			dF.ciphersuite<% write(getIndex("wlan_idx")); %>[0].checked=true;
			dF.ciphersuite<% write(getIndex("wlan_idx")); %>[1].checked=false;
		}
		else{
			alert("Error: not supported wpa cipher suite "+document.getElementById("pocket_wpa_tkip_aes").value);//Added for test
		}
	}
	else if((client_mode_support_wapi==1)&&(document.getElementById("pocket_encrypt").value == "WAPI"))
		get_by_id("method"+wlan_idx).selectedIndex = 4;
	else{
		alert("Error: not supported encrypt "+document.getElementById("pocket_encrypt").value);//Added for test
	}
		
	pocket_checkState(wlan_idx);
	enableButton(document.wizardPocket.connectBtn);
}

function saveClickSecurity(next)
{
	wizardHideDiv();
	
	if(next)
	{
		if(get_by_id("method"+wlan_idx).selectedIndex == 0)
			get_by_id("wepEnabled"+wlan_idx).value =  "OFF" ;
		else
			get_by_id("wepEnabled"+wlan_idx).value =  "ON" ;
			
		show_div(true, "wait_div");
		document.wizardPocket.submit();
	}
	else
	{
		show_div(true, ("top_div"));
		
	}
}

function init()
{	
	if(get_by_id("next"))
		disableTextField(get_by_id("next"));		
}

</script>
</head>
<body onload="init();">
<blockquote>
<h2><font color="#0000FF">Wireless Site Survey <% if (getIndex("wlan_num") > 1) write("-wlan"+(getIndex("wlan_idx")+1)); %></font></h2>

<table border=0 width="500" cellspacing=0 cellpadding=0>
<tr><font size=2>
 This page provides tool to scan the wireless network. If any Access Point or
 IBSS is found, you could choose to connect it manually when client mode is enabled.
</font></tr>
<tr><hr size=1 noshade align=top></tr>
</table>
<form action=/goform/formWlSiteSurvey method=POST name="wizardPocket">
<input type=hidden id="pocketAP_ssid" name="pocketAP_ssid" value=""> 
<input type=hidden id="pocket_channel" name="pocket_channel" value="">
<input type=hidden id="pocket_encrypt" name="pocket_encrypt" value="">
<input type=hidden id="pocket_wpa_tkip_aes" name="pocket_wpa_tkip_aes" value="">
<input type=hidden id="pocket_wpa2_tkip_aes" name="pocket_wpa2_tkip_aes" value="">
<input type=hidden id="wepEnabled<% write(getIndex("wlan_idx")); %>" name="wepEnabled<% write(getIndex("wlan_idx")); %>" value="OFF">	
<!--
<input type=hidden name="ciphersuite<% write(getIndex("wlan_idx")); %>" value="aes">
<input type=hidden name="wpa2ciphersuite<% write(getIndex("wlan_idx")); %>" value="aes">
-->
<input type=hidden name="select" value="">
<input type=hidden name="wlan_idx" value="<% write(getIndex("wlan_idx")); %>"*1>
<input type=hidden name="wlanif" value="wlan<% write(getIndex("wlan_idx")); %>">
<input type=hidden name="band<% write(getIndex("wlan_idx")); %>" value="<% write(getIndex("band"));	%>"*1-1> <!-- B+G+N -->
<input type=hidden name="mode<% write(getIndex("wlan_idx")); %>" value="<% write(getIndex("wlanMode"));%>"*1>
<input type=hidden name="wps_clear_configure_by_reg<% write(getIndex("wlan_idx")); %>" value=0>
<!--
<input type=hidden name="wpaAuth<% write(getIndex("wlan_idx")); %>" value="psk">
-->
</table>


<span id = "top_div" class = "on" >
<table border="0" width=500>
	<tr>
		<td><input type="button" value="Site Survey" name="refresh" onclick="SSIDSiteSurvey.window.siteSurvey(<% write(getIndex("wlan_idx")); %>);"></td>
	</tr>
</table>

<iframe id="SSIDSiteSurvey" name="SSIDSiteSurvey" onload="javascript:{dyniframesize();}" marginwidth="0" marginheight="0" frameborder="0" scrolling="no" src="pocket_sitesurvey.asp" width=800 height=0></iframe> 


<br>
<table border=0 width="500" cellspacing=4 cellpadding=0>  
	<tr> <td colspan="2" align=right>
		<SCRIPT>
			if(wlanMode == 1)
				document.write('<input type="button" value="  Next>>" id="next" onClick="saveClickSSID()">');
		</SCRIPT>
  </td> </tr>
</table>

</span>

<!-- pocketRouter Security -->
<span id = "wlan_security_div" class = "off" >

<br>

<table border=0 width="500" cellspacing=4 cellpadding=0>
   <td width="35%"><font size="2"><b>Encryption:&nbsp;</b>
        <select size="1" id=method<% write(getIndex("wlan_idx")); %> name=method<% write(getIndex("wlan_idx")); %> onChange=pocket_checkState(<% write(getIndex("wlan_idx")); %>)>
          <option  value="0">None</option>
          <option value="1">WEP</option>
          <option value="2">WPA</option>
	  <option value="4">WPA2</option>
	  <% getInfo("wapiOption");%>
        </select></font></td>
</table>

<span id = "wep_div" class = "off" >
<table border=0 width="500" cellspacing=4  cellpadding=0>
  <tr>
      <td width="15%"><font size=2><b>Key Length:</b></td>
      <td width="60%"><font size=2><select size="1" name=length<% write(getIndex("wlan_idx")); %> ONCHANGE="lengthClick(document.wizardPocket,0)">
      			<option value=1 >64-bit</option>
			<option value=2 >128-bit</option>
      </select></td>
  </tr>
  <tr>
      <td width="15%"><font size=2><b>Key Format:</b></td>
      <td width="40%"><font size=2><select size="1" name=format<% write(getIndex("wlan_idx")); %> ONCHANGE="setDefaultWEPKeyValue(document.wizardPocket,0)">
     	<option value=1>ASCII</option>
	<option value=2>Hex</option>
       </select></td>
  </tr>
  <tr>
     <td width="15%"><font size=2><b>Key Setting:</b></td>
     <td width="40%"><font size=2>
     	<input type="text" name=key<% write(getIndex("wlan_idx")); %> size="26" maxlength="26">
     </td>
  </tr>
</table>
</span>


<span id = "wpa_div" class = "off" >
   <table border=0 width="500" cellspacing=4 cellpadding=0>


   <tr>
	<td width="35%" ><font size="2"><b>Authentication Mode:</b></font></td>
	<td width="65%"><font size="2">
		<input name="wpaAuth<% write(getIndex("wlan_idx")); %>" type="radio" value="eap" onClick="show_wpa_settings()">Enterprise (RADIUS)
		<input name="wpaAuth<% write(getIndex("wlan_idx")); %>" type="radio" value="psk" onClick="show_wpa_settings()">Personal (Pre-Shared Key)
	</font>
   </td></tr>  

   <tr id="show_wpa_cipher" style="display:none">
	<td width="35%"><font size="2"><b>WPA Cipher Suite:</b></font></td>
	<td width="65%"><font size="2">
		<input type="checkbox" name="ciphersuite<% write(getIndex("wlan_idx")); %>" value="tkip">TKIP&nbsp;
		<input type="checkbox" name="ciphersuite<% write(getIndex("wlan_idx")); %>" value="aes">AES
	</font>
   </td></tr> 
	
   <tr id="show_wpa2_cipher" style="display:none">
	<td width="35%"><font size="2"><b>WPA2 Cipher Suite:</b></font></td>
	<td width="65%"><font size="2">
		<input type="checkbox" name="wpa2ciphersuite<% write(getIndex("wlan_idx")); %>" value="tkip">TKIP&nbsp;
		<input type="checkbox" name="wpa2ciphersuite<% write(getIndex("wlan_idx")); %>" value="aes">AES
	</font>
   </td></tr>

   <tr id="show_wpa_psk1" style="display:none">				
	<td width="35%"><font size="2"><b>Pre-Shared Key Format:</b></font></td>
	<td width="65%">
	<select id="psk_fmt" name="pskFormat<% write(getIndex("wlan_idx")); %>" onChange="">
		<option value="0">Passphrase</option>
		<option value="1">HEX (64 characters)</option>
		</select>
   </td></tr>
   
   <tr id="show_wpa_psk2" style="display:none">
	<td width="35%"><font size="2"><b>Pre-Shared&nbsp;Key:</b></font></td>
	<td width="65%"><input type="password" name="pskValue<% write(getIndex("wlan_idx")); %>" id="wpapsk" size="32" maxlength="64" value="">
   </td></tr>
  </table>
</span>

<span id = "show_8021x_eap_client" class = "off" >
	<table width="100%" border="0" cellpadding="0" cellspacing="4">
		<tr>
			 <td width="35%"><font size="2"><b>EAP Type:</b></font></td>					 
			 <td width="65%"><font size="2">
			 <select size="1"  id="eap_type" name="eapType<% write(getIndex("wlan_idx")); %>" onChange="change_1x_eap_type_settings()">	 
				<option value="0"> MD5 </option>
	 			<option value="1"> TLS </option>
				<option value="2"> PEAP </option>			
			</select> </font></td>
		</tr>
		<tr>
			 <td width="35%"><font size="2"><b>Inside Tunnel Type:</b></font></td>					 
			 <td width="65%"><font size="2">
			 <select size="1"  id="eap_inside_type" name="eapInsideType<% write(getIndex("wlan_idx")); %>" onChange="change_1x_eap_type_settings()">	 
	 			<option value="0"> MSCHAPV2 </option>
			 </select> </font></td>
		</tr>
		<tr>
			 <td width="35%"><font size="2"><b>EAP User ID:</b></font></td>
			 <td width="65%"><input id="eap_user_id" name="eapUserId<% write(getIndex("wlan_idx")); %>" size="24" maxlength="64" value=""></td>
		</tr>
		<tr>
			 <td width="35%"><font size="2"><b>RADIUS User Name:</b></font></td>
			 <td width="65%"><input id="radius_user_name" name="radiusUserName<% write(getIndex("wlan_idx")); %>" size="24" maxlength="64" value=""></td>
		</tr>
		<tr>
			<td width="35%"><font size="2"><b>RADIUS User Password:</b></font></td>
			<td width="65%"><input type="password" id="radius_user_pass" name="radiusUserPass<% write(getIndex("wlan_idx")); %>" size="24" maxlength="64" value=""></td>
		</tr>
		<tr>
			<td width="35%"><font size="2"><b>User Key Password (if any):</b></font></td>
			<td width="65%"><input type="password" id="radius_user_cert_pass" name="radiusUserCertPass<% write(getIndex("wlan_idx")); %>" size="24" maxlength="64" value=""></td>
		</tr>
	</table>								
</span>

<span id = "setting_wapi" class = "off" >
	<table width="100%" border="0" cellpadding="0" cellspacing="4">    
	        <tr>
	                <td width="35%"><font size="2"><b>Authentication Mode:</b></font></td>
	                <td width="65%"><font size="2">
	                        <input <% getInfo("wapiCertSupport"); %> name="wapiAuth<% write(getIndex("wlan_idx")); %>" type="radio" value="eap" onClick="show_wapi_settings()">Enterprise (AS Server)
	                        <input name="wapiAuth<% write(getIndex("wlan_idx")); %>" type="radio" value="psk" onClick="show_wapi_settings()">Personal (Pre-Shared Key)
	                                </font>
	        </td></tr>
		<tr id="show_wapi_psk1" style="display:none">
			<td width="35%"><font size="2"><b>Pre-Shared&nbsp;Key&nbsp;Format:</b></font></td>
			<td width="65%">
			<select id="wapi_psk_fmt" name="wapiPskFormat<% write(getIndex("wlan_idx")); %>" onChange="">
		                <option value="0">Passphrase</option>
		                <option value="1">HEX (64 characters)</option>
			</select>
		</td></tr>
	        <tr id="show_wapi_psk2" style="display:none">
	                <td width="35%"><font size="2"><b>Pre-Shared&nbsp;Key:</b></font></td>
	                <td width="65%"><input type="password" name="wapiPskValue<% write(getIndex("wlan_idx")); %>" id="wapipsk" size="32" maxlength="64" value="">
	        </td></tr>
	</table>
</span>

<span id = "show_8021x_wapi" class = "off" >
	<table width="100%" border="0" cellpadding="0" cellspacing="4">
		<tr id="show_8021x_wapi_local_as" style="">
			<td width="30%"><font size="2"><b>Use Local AS Server:</b></font></td>
			<td width="70%"><font size="2">
			<input type="checkbox" id="uselocalAS" name="uselocalAS<% write(getIndex("wlan_idx")); %>" value="ON" onClick="show_wapi_ASip()">
			</font>
		</td></tr>
		<tr>
		         <td width="30%"><font size="2"><b>AS&nbsp;Server&nbsp;IP&nbsp;Address:</b></font></td>
		         <td width="70%"><input id="wapiAS_ip" name="wapiASIP<% write(getIndex("wlan_idx")); %>" size="16" maxlength="15" value="0.0.0.0">
		</td></tr>
	</table>
</span>
  
  <br>
  <input type="button" value="<<Back  " name="back" onClick="saveClickSecurity(0)">
  <input type="button" value="Connect" name="connectBtn" onClick="saveClickSecurity(1)">
  <input type="hidden" value="connect" name="connect">
  <input type="hidden" value="/wlsurvey.asp" name="submit-url">
 <script>
 	var wlanState="<%getScheduleInfo("wlan_state");%>";
   	<% 	
   	
   		if (getIndex("wlanDisabled"))
     	  	write( "disableButton(document.formWlSiteSurvey.refresh);" );
 	 %>
 	 
 	 if (wlanState=="Disabled")
     	 	disableButton(document.wizardPocket.refresh);
 	 
		disableButton(document.wizardPocket.connectBtn);
 </script>
</span>

<span id = "wait_div" class = "off" >
Please wait...
</span>

</form>

</blockquote>
</body>
</html>