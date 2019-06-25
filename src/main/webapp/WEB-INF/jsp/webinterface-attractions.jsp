<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="sponsors" type="java.util.List<sponsoren.orm.SponsorEntity>"--%>
<%--@elvariable id="attractions" type="java.util.List<sponsoren.orm.AttraktionEntity>"--%>
<%--@elvariable id="attractionSponsors" type="java.util.Map<java.lang.String, java.lang.String>"--%>
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
    <!-- Sponsor Hinzufügen -->
    <div class="button-group">
        <button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown">
            <span class="glyphicon glyphicon-cog"></span><span class="caret"></span>
        </button>
        <ul class="dropdown-menu disabled" style="height: 400px; overflow: auto;">
            <c:forEach items="${sponsors}" var="sponsor">
                <li>
                    <label class="dropdown-item">
                        <input type="checkbox" id="checkbox-event-${event.id}-sponsor-${sponsor.name}"
                        <c:if test="${eventsSponsors.get(event.id).contains(sponsor.name)}">
                               checked
                        </c:if>
                        > &nbsp; ${sponsor.name}
                    </label>
                </li>
            </c:forEach>
        </ul>
    </div>

    <div class="button-group">
        <button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown">
            <span class="glyphicon glyphicon-cog"></span><span class="caret"></span>
        </button>
        <ul class="dropdown-menu disabled" style="height: 400px; overflow: auto;">
            <c:forEach items="${attractions}" var="attraktion">
                <li>
                    <label class="dropdown-item">
                        <input type="checkbox" id="checkbox-event-sponsor-${attraktion.name}"
                        > &nbsp; ${attraktion.name}
                    </label>
                </li>
            </c:forEach>
        </ul>
    </div>

    <div class="dropdown">
        <button id="dLabel" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            Dropdown trigger
        </button>
        <div class="dropdown-menu" aria-labelledby="dLabel">
            ...
        </div>
    </div>
</div>


<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
        integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
        crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
        integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
        crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
        integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
        crossorigin="anonymous"></script>

</body>
</html>
