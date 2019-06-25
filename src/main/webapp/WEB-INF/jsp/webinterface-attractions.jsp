<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="util" type="sponsoren.Util"--%>
<%--@elvariable id="sponsor" type="sponsoren.orm.SponsorEntity"--%>
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

    <!-- Own CSS -->
    <style>
        input:checked + strong {
            color: green;
        }

        input[type="checkbox"]:checked {
            box-shadow: 0 0 0 5px darkgreen;
        }
    </style>

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
        <p class="navbar-brand">Gesponserte Attraktionen</p>
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

<div class="container pt-5 mt-5 ">
    <div class="card pb-3">
        <div class="row justify-content-center">
            <div class="col-4">
                <h4 class="card-title">Attraktionen editieren</h4>
            </div>
        </div>
        <div class="row justify-content-center">
            <div class="col-4">
                <h6 class="card-title">${sponsor.name} sponsert folgende Attraktionen: </h6>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-4">
                <div class="button-group">
                    <button type="button" class="btn btn-outline-secondary dropdown-toggle" data-toggle="dropdown">
                        <span class="caret">Attraktionen</span>
                    </button>
                    <ul class="dropdown-menu keep-open disabled" style="height: 400px; overflow: auto;">
                        <c:forEach items="${attractions}" var="attraction">
                            <li>
                                <label class="dropdown-item">
                                    <input type="checkbox"
                                           id="checkbox-event-${attraction.id}-attraction-${attraction.name}"
                                    <c:if test="${attractionSponsors.get(attraction.name)==sponsor.name}">
                                           checked
                                    </c:if>
                                    > <strong>${attraction.name}</strong>
                                </label>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-4">
                <!-- Speichern Button -->
                <button id="button-save-attraction-" class="btn btn-primary btn-success mt-1"
                        onclick="saveVeranstaltung()" role="button">
                    Änderungen speichern
                </button>
            </div>
        </div>
    </div>
    <div class="card mt-5 pb-3">
        <div class="row justify-content-center">
            <div class="col-4">
                <h4 class="card-title">Überblick über gesponserte Attraktionen</h4>
            </div>
        </div>
        <div class="row justify-content-center">
            <div class="col-4">
                <div class="container-fluid ">
                    <div class="row justify-content-center">
                        <c:forEach items="${attractions}" var="attraction">
                            <c:if test="${attractionSponsors.get(attraction.name)==sponsor.name}">
                                <a id="attraction-${attraction.name}"
                                   href="https://seserver.se.hs-heilbronn.de:9443/buga19bugascout/#/details/${attraction.id}"
                                   target="_blank">
                                    <div class="card mb-2" style=" width: 312px;">
                                        <span class="d-block p-1 bg-light border-bottom text-dark text-center"><b>${attraction.name}</b></span>
                                        <div class="container">
                                            <div class="card-text text-dark" style="font-size: small">
                                                    ${util.truncateLongText(attraction.beschreibung, 350)}
                                            </div>
                                        </div>
                                        <a href="${context}/sponsor?name=${attractionSponsors.get(attraction.name)}"><span
                                                class="d-block p-1 bg-light border-top text-center"><b>Gesponsort von ${attractionSponsors.get(attraction.name)}</b></span>
                                        </a>
                                    </div>
                                </a>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </div>
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

<!-- own scripts -->
<script src="${context}/js/dropdownmenue.js"></script>

</body>
</html>
