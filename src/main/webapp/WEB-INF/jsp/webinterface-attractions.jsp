<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="sponsors" type="java.util.List<sponsoren.orm.SponsorEntity>"--%>
<c:set var="context" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
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

<nav class="navbar fixed-top navbar-expand-lg navbar-dark bg-dark mb-5">
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


<div class="container fluid pt-5 mt-5">
    <div class="button-group">
        <div class="input-group-prepend">
            <span class="input-group-text"><i class="fas fa-thumbtack"></i></span>
        </div>
        <button id="sponsor" class="btn btn-outline-secondary dropdown-toggle" type="button" data-toggle="dropdown">
            [sponsor]
        </button>
        <ul class="dropdown-menu" style="height: 400px; overflow: auto;">
            <c:forEach items="${sponsors}" var="sponsor">
                <li class="dropdown-item">
                    <input type="checkbox" >
                </li>
            </c:forEach>
        </ul>
    </div>
</div>




</body>
</html>
