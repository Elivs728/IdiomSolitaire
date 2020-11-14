<%@ page import="java.sql.*" %><%--
  Created by IntelliJ IDEA.
  User: lenovo
  Date: 2020/11/13
  Time: 19:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    request.setCharacterEncoding("utf-8");
    response.setContentType("text/html;charset=utf-8");
    String idiomComputer = request.getParameter("computerIdiom");
    String idiomLastWord = (String) session.getAttribute("idiomLastWord");
    String computerWord = (String) session.getAttribute("computerWord");
    if (!idiomComputer.substring(0, 1).equals(idiomLastWord)&&computerWord==null) {
        response.sendRedirect("error.jsp");
    }else{
        String url = "jdbc:mysql://localhost:3306/idiomsolitaire?useUnicode=true&characterEncoding=utf-8";
        String username = "root";
        String password = "123456";
        Connection conn = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");//加载JDBC驱动程序
            conn = DriverManager.getConnection(url, username, password);//链接数据库
        } catch (ClassNotFoundException e) {
            out.println("找不到驱动类");//抛出异常时，提示信息
        } catch (SQLException e) {
            out.println("链接MySQL数据库失败");//处理SQLException异常
        }

        if (idiomComputer != null&&idiomComputer.length()>=4) {
            try {
                String lastString = idiomComputer.substring(3, 4);
                Statement stmt = conn.createStatement();//创建语句对象Statement
                String sql = "select * from idiom where name like '%" + lastString + "%'";
                ResultSet resultSet = stmt.executeQuery(sql);
                session.setAttribute("resultSet",resultSet);
                String solitaireWord = null;
                while (resultSet.next()) {
                    solitaireWord = resultSet.getString(2);
                    if (solitaireWord.substring(0, 1).equals(lastString)) {
                        idiomComputer = solitaireWord;
                        break;
                    }
                }
                if (!solitaireWord.substring(0, 1).equals(lastString)){
                    out.print("请遵守规则，必须根据他的最后一个字来接龙");
                    response.setHeader("refresh","1;computer.jsp");
                }
                out.println("本电脑给出的成语是------->" + idiomComputer + "<br>");
                session.setAttribute("idiomComputer",idiomComputer);
                String computerLastWord = idiomComputer.substring(3, 4);
                session.setAttribute("computerLastWord",computerLastWord);
                out.println("请根据        " + computerLastWord + "       继续向下接龙" + "<br>");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
%>
<form action="result.jsp" method="post">
    <input type="text" name="computerWord">
    <input type="submit" value="又该你了">
</form>
<br>
<a href="computerPrompt.jsp">提示一下吧，真的不会了！！</a>
</body>
</html>
