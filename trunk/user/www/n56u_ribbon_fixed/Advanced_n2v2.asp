<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - N2V2组网</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/engage.itoggle.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/bootstrap/js/engage.itoggle.min.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/itoggle.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script>
var $j = jQuery.noConflict();

<% nelink_status(); %>
<% login_state_hook(); %>
$j(document).ready(function() {
	init_itoggle('n2v2_enable');
	$j("#tab_n2v2_cfg, #tab_nelink_web, #tab_n2v2_sta, #tab_n2v2_log").click(
	function () {
		var newHash = $j(this).attr('href').toLowerCase();
		showTab(newHash);
		return false;
	});

</script>
<script>
<% n2v2_status(); %>
<% login_state_hook(); %>

var m_list = [<% get_nvram_list("N2v2Conf", "N2v2List"); %>];
var mlist_ifield = 4;
if(m_list.length > 0){
	var m_list_ifield = m_list[0].length;
	for (var i = 0; i < m_list.length; i++) {
		m_list[i][mlist_ifield] = i;
	}
}
var isMenuopen = 0;
function initial(){
	show_banner(2);
	show_menu(5,17,0);
	showMRULESList();
	showmenu();
	fill_status(n2v2_status());
	show_footer();
}

function applyRule(){
	showLoading();
	
	document.form.action_mode.value = " Restart ";
	document.form.current_page.value = "/Advanced_n2v2.asp";
	document.form.next_page.value = "";
	
	document.form.submit();
}

function done_validating(action){
	refreshpage();
}

function fill_status(status_code){
	var stext = "Unknown";
	if (status_code == 0)
		stext = "<#Stopped#>";
	else if (status_code == 1)
		stext = "<#Running#>";
	$("n2v2_status").innerHTML = '<span class="label label-' + (status_code != 0 ? 'success' : 'warning') + '">' + stext + '</span>';
}

function markGroupRULES(o, c, b) {
	document.form.group_id.value = "N2v2List";
	if(b == " Add "){
		if (document.form.n2v2_staticnum_x_0.value >= c){
			alert("<#JS_itemlimit1#> " + c + " <#JS_itemlimit2#>");
			return false;
		}else if (document.form.n2v2_ip_x_0.value==""){
			alert("<#JS_fieldblank#>");
			document.form.n2v2_ip_x_0.focus();
			document.form.n2v2_ip_x_0.select();
			return false;
		}else if(document.form.n2v2_route_x_0.value==""){
			alert("<#JS_fieldblank#>");
			document.form.n2v2_route_x_0.focus();
			document.form.n2v2_route_x_0.select();
			return false;
		}else{
			for(i=0; i<m_list.length; i++){
				if(document.form.n2v2_ip_x_0.value==m_list[i][0]) {
				if(document.form.n2v2_route_x_0.value==m_list[i][1]) {
					alert('<#JS_duplicate#>' + ' (' + m_list[i][1] + ')' );
					document.form.n2v2_ip_x_0.focus();
					document.form.n2v2_ip_x_0.select();
					return false;
					}
				}
			}
		}
	}
	pageChanged = 0;
	document.form.action_mode.value = b;
	return true;
}

function showMRULESList(){
	var code = '<table width="100%" cellspacing="0" cellpadding="3" class="table table-list">';
	if(m_list.length == 0)
		code +='<tr><td colspan="4" style="text-align: center;"><div class="alert alert-info"><#IPConnection_VSList_Norule#></div></td></tr>';
	else{
	    for(var i = 0; i < m_list.length; i++){
		if(m_list[i][0] == 0)
		zero_enable="已禁用";
		else{
		zero_enable="已启用";
		}
		code +='<tr id="rowrl' + i + '">';
		code +='<td width="20%">&nbsp;' + n2v2_enable + '</td>';
		code +='<td width="40%">&nbsp;' + m_list[i][1] + '</td>';
		code +='<td width="40%">' + m_list[i][2] + '</td>';
		code +='<td width="50%"></td>';
		code +='<center><td width="20%" style="text-align: center;"><input type="checkbox" name="N2v2List_s" value="' + m_list[i][mlist_ifield] + '" onClick="changeBgColorrl(this,' + i + ');" id="check' + m_list[i][mlist_ifield] + '"></td></center>';
		
		code +='</tr>';
	    }
		code += '<tr>';
		code += '<td colspan="4">&nbsp;</td>'
		code += '<td><button class="btn btn-danger" type="submit" onclick="markGroupRULES(this, 64, \' Del \');" name="N2v2List"><i class="icon icon-minus icon-white"></i></button></td>';
		code += '</tr>'
	}
	code +='</table>';
	$("MRULESList_Block").innerHTML = code;
}

</script>
</head>

<body onload="initial();" onunLoad="return unload_body();">

<div class="wrapper">
	<div class="container-fluid" style="padding-right: 0px">
		<div class="row-fluid">
			<div class="span3"><center><div id="logo"></div></center></div>
			<div class="span9" >
				<div id="TopBanner"></div>
			</div>
		</div>
	</div>

	<div id="Loading" class="popup_bg"></div>

	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>

	<form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">

	<input type="hidden" name="current_page" value="Advanced_n2v2.asp">
	<input type="hidden" name="next_page" value="">
	<input type="hidden" name="next_host" value="">
	<input type="hidden" name="sid_list" value="N2v2Conf;">
	<input type="hidden" name="group_id" value="N2v2List">
	<input type="hidden" name="action_mode" value="">
	<input type="hidden" name="action_script" value="">
	<input type="hidden" name="zero_staticnum_x_0" value="<% nvram_get_x("N2v2List", "n2v2_staticnum_x"); %>" readonly="1" />

	<div class="container-fluid">
		<div class="row-fluid">
			<div class="span3">
				<!--Sidebar content-->
	<!--=====Beginning of Main Menu=====-->
	<div class="well sidebar-nav side_nav" style="padding: 0px;">
	<ul id="mainMenu" class="clearfix"></ul>
	<ul class="clearfix">
	<li>
	<div id="subMenu" class="accordion"></div>
	</li>
	</ul>
	</div>
	</div>
	<div class="span9">
	<!--Body content-->
	<div class="row-fluid">
	<div class="span12">
	<div class="box well grad_colour_dark_blue">
	<h2 class="box_head round_top">N2V2智能组网</h2>
	<div class="round_bottom">
	<div>
	<ul class="nav nav-tabs" style="margin-bottom: 10px;">
	<li class="active"><a id="tab_n2v2_cfg" href="#cfg">基本设置</a></li>
	<li><a id="tab_n2v2_log" href="#log">运行日志</a></li>
	</th>
	</tr>
	<tr>
	</div>
	<div class="row-fluid">
									<div id="tabMenu" class="submenuBlock"></div>
									<div class="alert alert-info" style="margin: 10px;">
									<p>N2V2智能组网是一个易于配置异地组网 直连技术<br>
									</p>
									</div>
										<table width="100%" align="center" cellpadding="4" cellspacing="0" class="table">
									<tr> <th><#running_status#></th>
                                            <td id="n2v2_status" colspan="3"></td>
                                        </tr><td></td><td></td><td></td>
										<tr>
										<tr>
										<th width="30%" style="border-top: 0 none;">启用组网客户端</th>
											<td style="border-top: 0 none;">
													<div class="main_itoggle">
													<div id="nelink_enable_on_of">
														<input type="checkbox" id="n2v2_enable_fake" <% nvram_match_x("", "n2v2_enable", "1", "value=1 checked"); %><% nvram_match_x("", "n2v2_enable", "0", "value=0"); %>  />
													</div>
												</div>
												<div style="position: absolute; margin-left: -10000px;">
													<input type="radio" value="1" name="n2v2_enable" id="n2v2_enable_1" class="input" value="1" <% nvram_match_x("", "n2v2_enable", "1", "checked"); %> /><#checkbox_Yes#>
													<input type="radio" value="0" name="n2v2_enable" id="n2v2_enable_0" class="input" value="0" <% nvram_match_x("", "n2v2_enable", "0", "checked"); %> /><#checkbox_No#>
												</div>
											</td>

										</tr>

										<tr>
										<th>本机识别码(不要改动) </th>
				<td>
					<input type="text" class="input" readonly name="n2v2_keyg" id="n2v2_keyg" style="width: 200px" value="<% nvram_get_x("","n2v2_keyg"); %>" />
				</td>

										</tr>

										<tr>
										<th>本机虚拟ip（格式 20）</th>
				<td>
					<input type="text" class="input" name="n2v2_ip" id="n2v2_ip" style="width: 30px" value="<% nvram_get_x("","n2v2_ip"); %>" />
				</td>

										</tr>
										<tr>
										<th>节点地址</th>
				<td>
					<input type="text" class="input" readonly name="n2v2_log" id="n2v2_log" style="width: 240px" value="<% nvram_get_x("","n2v2_log"); %>" />
				</td>


										</tr>
										<tr>
										<th>开起第2个设备(不用留空）</th>
				<td>
					<input type="text" class="input" name="n2v2_log2" id="n2v2_log2" style="width: 240px" value="<% nvram_get_x("","n2v2_log2"); %>" />
				</td>

										</tr>
										<tr>
										<th>开起第3个设备(route add -net inip/24 gw xuip）</th>
				<td>
					<input type="text" class="input" name="n2v2_log3" id="n2v2_log3" style="width: 240px" value="<% nvram_get_x("","n2v2_log3"); %>" />
				</td>

										</tr>
										<tr>
									</table>
<table width="100%" align="center" cellpadding="4" cellspacing="0" class="table">
	<tr> <th colspan="4">需要访问其它n2v2的内网LAN网段,IP和网关和n2v2后台对应即可(本机的LAN网段不用填进去)</th></tr>
                                        <tr id="row_rules_caption">
										 
                                            <th width="10%">
                                                启用 <i class="icon-circle-arrow-down"></i>
                                            </th>
											<th width="20%">
                                                IP <i class="icon-circle-arrow-down"></i>
                                            </th>
											<th width="25%">
                                                网关 <i class="icon-circle-arrow-down"></i>
                                            </th>
                                            <th width="5%">
                                                <center><i class="icon-th-list"></i></center>
                                            </th>
                                        </tr>
                                         <tr>
                                         	<th>
                                          	<select name="n2v2_enable_x_0" class="input" style="width: 100px">
													<option value="1" <% nvram_match_x("","n2v2_enable_x_0", "0","selected"); %>>是</option>
													<option value="0" <% nvram_match_x("","n2v2_enable_x_0", "0","selected"); %>>否</option>
												</select>
                                           </th>
                                         <th><input type="text" maxlength="255" class="span12" style="width: 200px" size="200" name="n2v2_ip_x_0" value="<% nvram_get_x("", "n2v2_ip_x_0"); %>"/>
                                            </th>
                                         <th>
                                                <input type="text" maxlength="255" class="span12" style="width: 200px" size="200" name="n2v2_route_x_0" value="<% nvram_get_x("", "n2v2_route_x_0"); %>" />
                                            </th>
                                         <th>
                                                <button class="btn" style="max-width: 219px" type="submit" onclick="return markGroupRULES(this, 64, ' Add ');" name="markGroupRULES2" value="<#CTL_add#>" size="12"><i class="icon icon-plus"></i></button>
                                            </th>
                                            </td>
                                        </tr>
                                        <tr id="row_rules_body" >
                                            <td colspan="4" style="border-top: 0 none; padding: 0px;">
                                                <div id="MRULESList_Block"></div>
                                            </td>
                                        </tr>
										</table>
										<tr>
											<td colspan="4" style="border-top: 0 none;">
												<br />
												<center><input class="btn btn-primary" style="width: 219px" type="button" value="<#CTL_apply#>" onclick="applyRule()" /></center>
											</td>
										</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	</form>

	<div id="footer"></div>
</div>
</body>
</html>
