<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="util" type="sponsoren.Util"--%>
<%--@elvariable id="events" type="java.lang.List<sponsoren.orm.VeranstaltungEntity>"--%>
<%--@elvariable id="locations" type="java.util.Map<Integer, sponsoren.orm.LocationEntity>"--%>
<c:set var="context" value="${pageContext.request.contextPath}" />

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
        .navbar-center
        {
            position: absolute;
            overflow: visible;
            height: 0;
            width: 100%;
            left: 0;
            top: 0;
            text-align: center;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark" style="min-width: 425px">
    <p class="navbar-text navbar-center text-white">Veranstaltungen</p>
    <a class="navbar-brand" href="${context}/sponsoren"><i class="fas fa-home"></i></a>
    <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
        <li class="nav-item active ml-1">

        </li>
    </ul>
</nav>
<table class="table table-bordered table-striped text-wrap" style="max-width: none">
    <thead>
    <tr>
        <th style="width: 150px;" class="text-wrap">Veranstaltung</th>
        <th style="width: 150px;" class="text-wrap">Ort</th>
        <th style="width: 150px;" class="text-wrap">Datum</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${events}" var="event">
        <tr>
            <td><a href="${context}/event?id=${event.id}" class="text-decoration-none">${event.name}</a></td>
            <td>${locations.get(event.locationID).name}</td>
            <td>${util.prettifyTimestamp(event.start)} bis ${util.prettifyTimestamp(event.ende)}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</body>
</html>
