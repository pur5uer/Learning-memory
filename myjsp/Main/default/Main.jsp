<%@ page contentType="text/html;charset=UTF-8" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>实验室后台管理</title>
<%
  session.setAttribute("username",null);
  session.setAttribute("is_out","0"); 
%>
<frameset rows="14%,84%">
  <frame src="../head.jsp">    //头部的jsp文件
  <frameset cols="15%,75%">
    <frame src="default_function.jsp">       //左边的jsp文件
    <frame src="../default.jsp" name="rightframe">   //右边的jsp页面
  </frameset>
</frameset>
</head>
