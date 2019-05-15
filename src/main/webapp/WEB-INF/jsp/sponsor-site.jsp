<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="util" type="sponsoren.Util"--%>
<%--@elvariable id="sponsor" type="sponsoren.orm.SponsorEntity"--%>
<%--@elvariable id="sponsorEvents" type="java.util.List<sponsoren.orm.VeranstaltungEntity>"--%>
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

    <title>${sponsor.name} - Sponsoren</title>

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
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <p class="navbar-text navbar-center text-white">${sponsor.name}</p>
    <a class="navbar-brand" href="${context}/sponsoren"><i class="fas fa-home"></i></a>
    <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
    </ul>
</nav>
<div class="container">
    <div class="row">
        <div class="col-12">
            <div class="shadow p-3 mb-5 bg-white rounded">
            <div class="card">
                <div class="text-center">
                    <img src="${context}/img/${sponsor.name}_scaled.png" style="max-height: 250px; max-width: 250px" class="card-img-thumbnail" alt="...">
                </div>
                <div class="card-body">
                    <span class="d-block p-1 bg-dark text-white text-center">Zum Sponsor</span>
                    <br>
                    <p class="card-text">${sponsor.beschreibung}</p>
                    <a href="${sponsor.homepage}" class="text-decoration-none">Website</a>
                </div>
                <div class="card-body">
                    <span class="d-block p-1 bg-dark text-white text-center">Rolle bei der BuGa</span>
                    <br>
                    <p class="card-text">${sponsor.werbetext}</p>
                </div>
                <div class="card-body">
                    <span class="d-block p-1 bg-dark text-white text-center">Kontakt</span>
                    <br>
                    <p class="card-text">${sponsor.ansprechpartnerNachname}<c:if test="${sponsor.ansprechpartnerVorname.length() > 0 && sponsor.ansprechpartnerNachname.length() > 0}">, </c:if>${sponsor.ansprechpartnerVorname}</p>
                    <p class="card-text">${sponsor.email} </p>
                    <p class="card-text">${sponsor.telefonnummer}</p>
                    <p class="card-text">${sponsor.adresse}<c:if test="${sponsor.adresse.length() > 0 && ( sponsor.plz.length() > 0 || sponsor.ort.length() > 0) }">, </c:if> ${sponsor.plz} ${sponsor.ort}</p>
                </div>
                <div class="row">
                    <div class="col-12">
                        <div class="card-body">
                            <span class="d-block p-1 bg-dark text-white text-center">Veranstaltungen</span>
                        </div>
                    </div>
                        <br>
                    <c:forEach items="${sponsorEvents}" var="event">
                        <div class="col-12 col-md-6">
                            <div class="card-body">
                                <h5 class="card-title"><a href="${context}/event?id=${event.id}" class="text-decoration-none">${event.name}</a></h5>
                                <p class="card-text">
                                    <c:if test="${event.beschreibung.length() > 0}">${event.beschreibung}</c:if>
                                    <c:if test="${event.beschreibung == null || event.beschreibung.length() == 0}"><i>(keine Beschreibung vorhanden)</i></c:if>
                                </p>
                                <p class="card-text">
                                    Ort: ${locations.get(event.locationID).name}<br>
                                    Zeitraum: ${util.prettifyTimestamp(event.start)} bis ${util.prettifyTimestamp(event.ende)}
                                </p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            </div>
        </div>
    </div>



</div>


<!-- Optional JavaScript -->
<!-- jQuery first, then Popper.js, then Bootstrap JS -->
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
