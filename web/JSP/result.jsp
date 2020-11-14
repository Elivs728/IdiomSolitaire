<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Collections" %><%--
  Created by IntelliJ IDEA.
  User: lenovo
  Date: 2020/11/13
  Time: 14:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>接龙</title>
</head>
<body>
<br>
<%
    request.setCharacterEncoding("utf-8");
    response.setContentType("text/html;charset=utf-8");
    String url = "jdbc:mysql://localhost:3306/idiomsolitaire?useUnicode=true&characterEncoding=utf-8";
    String username = "root";
    String password = "123456";
    Connection conn = null;
    String idiom = (String) session.getAttribute("idiom");
    String computerWord = request.getParameter("computerWord");
    try {
        Class.forName("com.mysql.jdbc.Driver");//加载JDBC驱动程序
        conn = DriverManager.getConnection(url, username, password);//链接数据库
    } catch (ClassNotFoundException e) {
        out.println("找不到驱动类");//抛出异常时，提示信息
    } catch (SQLException e) {
        out.println("链接MySQL数据库失败");//处理SQLException异常
    }
    if (idiom != null && computerWord == null) {
        out.println("本电脑给出的成语是------->" + idiom + "<br>");
        String idiomLastWord = idiom.substring(3, 4);
        session.setAttribute("idiomLastWord", idiomLastWord);
        out.println("请根据------>" + idiomLastWord + "<--------继续向下接龙" + "<br>");
    }
    String solitaireWord = null;
    String lastString = null;
    if (computerWord != null) {
        String computerLastWord = (String) session.getAttribute("computerLastWord");

        try {
            lastString = computerWord.substring(3, 4);
            Statement stmt = conn.createStatement();//创建语句对象Statement
            String sql = "select * from idiom where name like '%" + lastString + "%'";
            ResultSet resultSet = stmt.executeQuery(sql);
            while (resultSet.next()) {
                solitaireWord = resultSet.getString(2);
                if (solitaireWord.substring(0, 1).equals(lastString) && solitaireWord.length() == 4) {
                    computerWord = solitaireWord;
                    break;
                }
            }
            if (!solitaireWord.substring(0, 1).equals(lastString)) {
                out.print("请遵守规则，必须根据他的最后一个字来接龙");
                response.setHeader("refresh", "1;result.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        out.println("本电脑给出的成语是------->" + computerWord + "<br>");
        session.setAttribute("computerWord", computerWord);
        computerLastWord = computerWord.substring(3, 4);
        out.println("请根据        " + computerLastWord + "       继续向下接龙" + "<br>");
    }
%>
<br>
<h3>我已经接出来了，看看你可以接出来吗？</h3>
<form action="computer.jsp" method="post">
    <input type="text" name="computerIdiom">
    <input type="submit" value="该你了！">
</form>
<br>
<a href="prompt.jsp">
    提醒一下吧，真的想不出来啦！
</a>
</body>
</html>
