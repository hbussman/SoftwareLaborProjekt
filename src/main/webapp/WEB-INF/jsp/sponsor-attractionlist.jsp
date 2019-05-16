<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="util" type="sponsoren.Util"--%>
<%--@elvariable id="attractions" type="java.util.List<sponsoren.orm.AttraktionEntity>"--%>
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

    <title>Sponsoren-Attraktionenliste</title>
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
<body>
<nav class="navbar fixed-top navbar-dark bg-dark" style="min-height: 50px">
    <p class="navbar-text navbar-center text-white" style="font-size: x-large">Attraktionen</p>
</nav>
<nav class="navbar fixed-bottom navbar-expand-lg navbar-dark bg-dark justify-content-center">
    <div class="btn-group" role="group" aria-label="Basic example" style="min-width: 100%">
        <a id="Attractionbutton" class="btn btn-primary btn-light disabled" aria-disabled="true"
           href="${context}/attracions" role="button"><i class="fas fa-landmark"></i></a>
        <a id="Homebutton" class="btn btn-primary btn-light" aria-disabled="false" href="${context}/sponsoren"
           style="background: aquamarine"><i class="fas fa-home"></i></a>
        <a id="Eventbutton" class="btn btn-primary btn-light " href="${context}/events" role="button"
           aria-disabled="false"><i class="far fa-calendar-alt"></i>
        </a>
    </div>
</nav>
<div class="pt-5"></div>
<div class="container bg-image">
    <div class="row justify-content-center pb-5 mx-1">
    <c:forEach items="${attractions}" var="attraction">
        <a id="attraction-${attraction.name}" href="https://seserver.se.hs-heilbronn.de:9443/buga19bugascout?attraction=${attraction.name}">
            <div class="card mb-2" style=" width: 312px;">
                <span class="d-block p-1 bg-light text-dark text-center"><b>${attraction.name}</b></span>
                <div class="container">
                    <div class="card-text text-dark" style="font-size: small">
                        ${util.truncateLongText(attraction.beschreibung, 350)}
                    </div>
                </div>
            </div>
        </a>
    </c:forEach>

</div>
</body>
</html>
