<%--
  Created by IntelliJ IDEA.
  User: danie
  Date: 25.06.2019
  Time: 14:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css"
          integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">


    <title>Attraktionen</title>
</head>

<body>

<nav class="navbar fixed-top navbar-expand-lg navbar-dark bg-dark">
    <div class="pr-2">
        <a id="Sponsorenseitebutton" class="btn btn-light" href="${context}/webinterface"
           role="button" aria-disabled="true">Sponsorenseite
        </a>
    </div>
    <div class="pr-2">
        <a id="Accountbutton" class="btn btn-light" href="${context}/webinterface/account"
           role="button">Account
        </a>
    </div>
    <div class="mx-auto">
        <a class="navbar-brand" href="#">Navbar</a>
    </div>
    <div class="pr-2">
        <a id="Attraktionsbutton" class="btn btn-light disabled" href="${context}/webinterface/attractions"
           role="button">Attraktionen
        </a>
        <a id="Veranstaltungsbutton" class="btn btn-light" href="${context}/webinterface/events"
           role="button">Veranstaltungen
        </a>
    </div>
    <a id="logoutbutton" class="btn btn-danger" href="${context}/logout" role="button"><i
            class="fa fa-sign-out-alt"></i>
    </a>
</nav>

</body>
</html>
