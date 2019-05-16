<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="util" type="sponsoren.Util"--%>
<%--@elvariable id="events" type="java.lang.List<sponsoren.orm.VeranstaltungEntity>"--%>
<%--@elvariable id="locations" type="java.util.Map<Integer, sponsoren.orm.LocationEntity>"--%>
<c:set var="context" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css"
          integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">

    <!-- own scripts -->
    <script src="${context}/js/api_client.js"></script>
    <script>api_set_context("${context}")</script>

    <title>Sponsoren-Veranstaltungsliste</title>
    <style>
        .navbar-center {
            position: absolute;
            overflow: visible;
            height: 0;
            width: 100%;
            left: 0;
            top: 0;
            text-align: center;
        }

        .table-striped > tbody > tr:nth-child(odd) > th {
            background-color: aquamarine;
        }

        .bg-image {
            background-image: url(https://imgur.com/LkSvZHY.jpg);
            height: 100%;
            background-position: bottom center;
            background-attachment: fixed;
            background-repeat: no-repeat;
            background-size: cover;;
        }
    </style>
</head>
<body class="bg-image">
<nav class="navbar fixed-top navbar-dark bg-dark" style="min-height: 50px">
    <p class="navbar-text navbar-center text-white" style="font-size: x-large">Veranstaltungen</p>
</nav>
<nav class="navbar fixed-bottom navbar-expand-lg navbar-dark bg-dark justify-content-center">
    <div class="btn-group" role="group" aria-label="Basic example" style="min-width: 100%">
        <a id="Attractionbutton" class="btn btn-primary btn-light" href="${context}/attractions" role="button"><i
                class="fas fa-landmark"></i></a>
        <a id="Homebutton" class="btn btn-primary btn-light" aria-disabled="false" href="${context}/sponsoren"
           style="background: aquamarine"><i class="fas fa-home"></i></a>
        <a id="Eventbutton" class="btn btn-primary btn-light disabled" href="${context}/events" role="button"
           aria-disabled="true"><i class="far fa-calendar-alt"></i>
        </a>
    </div>
</nav>
<div class="pt-5"></div>
<div class="container">
<div class="row justify-content-center pb-5 mx-1">
    <c:forEach items="${events}" var="event">
        <a id="${event.id}card" href="${context}/event?id=${event.id}">
            <div class="card mb-2 col-12" style="max-height: 200px">
                <span class="d-block p-1 bg-light text-dark text-center"><b>${event.name}</b></span>
                <div class="card-body text-dark"><i class="fas fa-thumbtack"></i>
                        ${locations.get(event.locationID).name}
                    <div class="card-text text-dark"><i
                            class="far fa-calendar-alt"></i> ${util.prettifyTimestamp(event.start)}
                        - ${util.prettifyTimestamp(event.ende)}</div>
                </div>
            </div>
        </a>
    </c:forEach>
</div>
</div>
</body>
</html>
