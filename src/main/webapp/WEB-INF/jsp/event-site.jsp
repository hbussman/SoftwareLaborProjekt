<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="util" type="sponsoren.Util"--%>
<%--@elvariable id="event" type="sponsoren.orm.VeranstaltungEntity"--%>
<%--@elvariable id="eventSponsors" type="java.util.List<sponsoren.orm.SponsorEntity>"--%>
<%--@elvariable id="locations" type="java.util.Map<Integer, sponsoren.orm.LocationEntity>"--%>
<c:set var="context" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
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

    <title>Event-site</title>
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
<nav class="navbar fixed-top navbar-expand-lg navbar-dark bg-dark">
    <p class="navbar-text navbar-center text-white"style="font-size: x-large">${event.name}</p>
    <a class="btn btn-primary btn-light" href="${context}/sponsoren"><i class="fas fa-home"></i></a>
    <ul class="nav navbar-nav ml-auto "></ul>
    <a class="btn btn-primary btn-light" href="${context}/events" role="button"><i class="far fa-calendar-alt"></i>
    </a>
</nav>

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <p class="h4 pt-4 pb-0">${event.name}
            <p>
                <div class="card border-0 pt-0">
                    <div class="card-body">
                        <div class="text-start">
            <p class="card-text">${event.beschreibung}</p>
            <p class="card-text">
                Ort: ${locations.get(event.locationID).name}<br>
                Zeitraum: ${util.prettifyTimestamp(event.start)} bis ${util.prettifyTimestamp(event.ende)}
            </p>
        </div>
    </div>
</div>

<p class="h4">Gesponsort durch</p>
<div class="row no-gutters justify-content-xs-center">

    <c:forEach items="${eventSponsors}" var="sponsor">
        <div class="col col-lg-4 col-md-4 col-sm-4 col-6 pb-md-4 pb-sm-3 pl-md-4 pl-sm-3 d-flex align-items-stretch">
            <div class="card px-0">
                <img src="${imagesBase}/${sponsor.name}_scaled.png" class="card-img-top" alt="${sponsor.name}-Logo">
                <div class="card-body  px-0 pt-0 pb-0">
                    <p class="text--nowrap">${sponsor.name}</p>
                </div>
                <div class="card-footer bg-transparent px-0 pt-0 pb-0 border-0">
                    <a href="${context}/sponsor?name=${sponsor.name}" class="btn btn-dark mt-auto">Mehr Erfahren</a>
                </div>
            </div>
        </div>
    </c:forEach>

</div>


</body>
</html>
