<%@ page import="java.sql.*" %><%--
  Created by IntelliJ IDEA.
  User: lenovo
  Date: 2020/11/14
  Time: 12:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    if (session!=null) {
        request.setCharacterEncoding("utf-8");
        response.setContentType("text/html;charset=utf-8");
        String url = "jdbc:mysql://localhost:3306/idiomsolitaire?useUnicode=true&characterEncoding=utf-8";
        String username = "root";
        String password = "123456";
        Connection conn = null;
        String idiomComputer = (String) session.getAttribute("idiomComputer");
        try {
            Class.forName("com.mysql.jdbc.Driver");//加载JDBC驱动程序
            conn = DriverManager.getConnection(url, username, password);//链接数据库
        } catch (ClassNotFoundException e) {
            out.println("找不到驱动类");//抛出异常时，提示信息
        } catch (SQLException e) {
            out.println("链接MySQL数据库失败");//处理SQLException异常
        }
        if (idiomComputer != null) {
            try {
                String lastString = idiomComputer.substring(3, 4);
                Statement stmt = conn.createStatement();//创建语句对象Statement
                String sql = "select * from idiom where name like '%" + lastString + "%'";
                ResultSet resultSet = stmt.executeQuery(sql);
                while (resultSet.next()) {
                    String solitaireWord = resultSet.getString(2);
                    String Spell = resultSet.getString(3);
                    String Content = resultSet.getString(4);
                    String Derivation = resultSet.getString(5);
                    String Samples = resultSet.getString(6);
                    if (solitaireWord.substring(0, 1).equals(lastString)) {
                        out.print("成语：" + solitaireWord + "<br>");
                        out.print("Spell：" + Spell + "<br>");
                        out.print("Content：" + Content + "<br>");
                        out.print("Derivation：" + Derivation + "<br>");
                        out.print("Samples：" + Samples + "<br>");
                    }else {
                        response.setHeader("refresh","2;unknow.jsp");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
%>
</body>
</html>
