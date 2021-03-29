<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<html>
<style>
    .d1 {
        padding-top: 15px;
        margin: 150px auto;
        width:250px;height:130px;
        border-radius:10px;
    }
</style>
<head>
<title>通过JSP打开数据表</title>
</head>
<div class="d1">
<body>
 <%
         int r;
         request.setCharacterEncoding("utf-8");
         String studentname = request.getParameter("studentname");
         String studentid = request.getParameter("studentid");
         String machineid = request.getParameter("machineid");
         String feverstatus = request.getParameter("feverstatus");

        try {
            //********************************先改数据库的连接***************************************
            //数据库的连接
            Class.forName("com.mysql.cj.jdbc.Driver");  ////驱动程序名
            String url = "jdbc:mysql://localhost:3306/lab"+ "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true"; //数据库名
            String username = "root";  //数据库用户名
            String password = "123123";  //数据库用户密码
            Connection conn = DriverManager.getConnection(url, username, password);  //连接状态

            if(conn != null){
                out.print("数据库连接成功！" + "<br />");
                Statement stmt = null;Statement stm = null;                   //查询语句
                ResultSet rs = null;
                String sql = "SELECT * FROM students WHERE StudentId = \"" + studentid + "\";";          //按id查询
                stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
                stm = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
                rs = stmt.executeQuery(sql);

                //数据库查询结果的处理
                out.print("查询结果：" + "<br />");
                rs.last();
                if(rs.getRow() == 0) {
                    out.print("查无此人或学号错误！" + "<br />");
                } else {

                    //信息匹配
                    if(studentname.equals(rs.getString("Name")) && machineid.equals(rs.getString("MachineId"))) {
                        if(feverstatus.equals("1")) {          //判断是否高烧
                            if(rs.getString("FeverStatus").equals("0")) {
                                //**************信息报告********************
                                if(rs.getString("MachineStatus").equals("0")) {
                                    out.print("抱歉，发热的学生不允许进入！"+ "<br/>");                 //不发热变为发热，签到
                                    request.getSession().setAttribute("feversituation","#FF0000");
                                    request.getSession().setAttribute("fevername",studentname);
                                    request.getSession().setAttribute("feverid",studentid);
                                    request.getSession().setAttribute("fevermachine",machineid);
                                }else {
                                    out.print("实验室内人员出现发热！不允许外出！"+ "<br/>");           //不发热变为发热，签退
                                    request.getSession().setAttribute("feversituation","#0F0F0F");
                                    request.getSession().setAttribute("fevername",studentname);
                                    request.getSession().setAttribute("feverid",studentid);
                                    request.getSession().setAttribute("fevermachine",machineid);
                                }
                                //***************更新发热的状态****************
                                sql = "UPDATE students set FeverStatus = \"1\" WHERE StudentId = \"" + studentid + "\"";
                                r = stm.executeUpdate(sql);
                                if(r == 0) out.print("发热状态更新失败！"+ "<br/>");
                                else out.print("发热状态更新为发热"+ "<br/>");
                            } else {
                                if(rs.getString("MachineStatus").equals("0")) {                      //一直在发热，签到
                                    out.print("抱歉，发热的学生不允许进入！"+ "<br/>");
                                    request.getSession().setAttribute("feversituation","#CD2626");
                                    request.getSession().setAttribute("fevername",studentname);
                                    request.getSession().setAttribute("feverid",studentid);
                                    request.getSession().setAttribute("fevermachine",machineid);
                                }else {
                                    out.print("实验室内人员出现发热！不允许外出！"+ "<br/>");            //一直在发热，签退
                                    out.print("抱歉，发热的学生不允许进入！"+ "<br/>");
                                    request.getSession().setAttribute("feversituation","#737373");
                                    request.getSession().setAttribute("fevername",studentname);
                                    request.getSession().setAttribute("feverid",studentid);
                                    request.getSession().setAttribute("fevermachine",machineid);
                                }
                            }
                        } else {
                            //**************信息报告********************
                            if(rs.getString("FeverStatus").equals("1")) {
                                if(rs.getString("MachineStatus").equals("0")) {                            //发热变为不发热，签到
                                    request.getSession().setAttribute("feversituation","#9BCD9B");
                                    request.getSession().setAttribute("fevername",studentname);
                                    request.getSession().setAttribute("feverid",studentid);
                                    request.getSession().setAttribute("fevermachine",machineid);
                                } else {
                                    request.getSession().setAttribute("feversituation","#7B68EE");         //发热变为不发热，签退
                                    request.getSession().setAttribute("fevername",studentname);
                                    request.getSession().setAttribute("feverid",studentid);
                                    request.getSession().setAttribute("fevermachine",machineid);
                                }
                            }
                            //签到&签退
                            if(rs.getString("MachineStatus").equals("0")) {
                                sql = "UPDATE students set MachineStatus = \"1\" WHERE StudentId = \"" + studentid + "\"";
                                r = stm.executeUpdate(sql);
                                if(r == 0) out.print("签到失败！"+ "<br/>");
                                else out.print("状态更新为在线"+ "<br/>");
                            }
                            else {
                                sql = "UPDATE students set MachineStatus = \"0\" WHERE StudentId = \"" + studentid + "\"";
                                r = stm.executeUpdate(sql);
                                if(r == 0) out.print("签退失败！"+ "<br/>");
                                else out.print("状态更新为离线"+ "<br/>");
                            }
                            //***************更新发热的状态****************
                            if(rs.getString("FeverStatus").equals("1")) {
                                sql = "UPDATE students set FeverStatus = \"0\" WHERE StudentId = \"" + studentid + "\"";
                                r = stm.executeUpdate(sql);
                                if(r == 0) out.print("发热状态更新失败！"+ "<br/>");
                                else out.print("发热状态更新为不发热"+ "<br/>");
                            }
                        }
                    } else {
                        out.print("学号姓名或者座位不匹配"+ "<br/>");
                    }
                }
            } else{
                out.print("数据库连接失败！");
            }
        }catch (Exception e) {
            out.print("数据库连接异常！");
        }
%>
</body>
</div>
</html>
