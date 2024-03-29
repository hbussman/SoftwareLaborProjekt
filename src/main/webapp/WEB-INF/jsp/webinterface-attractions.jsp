<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="util" type="sponsoren.Util"--%>
<%--@elvariable id="sponsor" type="sponsoren.orm.SponsorEntity"--%>
<%--@elvariable id="sponsors" type="java.util.List<sponsoren.orm.SponsorEntity>"--%>
<%--@elvariable id="attractions" type="java.util.List<sponsoren.orm.AttraktionEntity>"--%>
<%--@elvariable id="sponsorAttractions" type="java.util.List<sponsoren.orm.AttraktionEntity>"--%>
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

    <script src="${context}/js/api_client.js"></script>
    <script>api_set_context("${context}")</script>

    <title>Attraktionen</title>

    <script>
        function saveAttractions() {

            var attractions = {};

            var ul = document.getElementById('attraction-selector');
            var lis = ul.getElementsByTagName('li');
            for(var i = 0; i < lis.length; i++) {
                var li = lis[i];
                var checked = li.children[0].children[0].checked;
                var sponsorName = li.children[0].children[1].innerText;
                console.log(sponsorName + " " + (checked ? "yes" : "no"));

                attractions[sponsorName] = checked;
            }

            console.log(attractions);

            db_save_attractions(attractions).then(result => {
                console.log(result.status);
                var resultElement = document.getElementById("ResultStatus");
                if(result.ok) {
                    result.text().then(text => {
                        //resultElement.style.color = "darkgreen";
                        //resultElement.innerText = "Änderungen erfolgreich gespeichert! " + text;
                        console.log(text);
                        location.reload();
                    });
                } else {
                    result.text().then(text => {
                        resultElement.style.color = "red";
                        resultElement.innerText = "Ein Fehler ist aufgetreten: " + result.status + " (" + text + ")"
                    });
                }
            });
        }
    </script>

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
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark justify-content-center">
    <div class="pr-2">
        <a id="Homebutton" class="btn btn-light" href="${context}/webinterface/"
           role="button">Sponsorenseite
        </a>
    </div>
    <div class="pr-2">
        <a id="Accountbutton" class="btn btn-light" href="${context}/webinterface/account"
           role="button">Account
        </a>
    </div>
    <ul class="nav navbar-nav ml-auto">
        <p class="navbar-text navbar-center text-white" style="font-size: x-large">Attraktionen verwalten</p>
    </ul>
    <div class="pr-2">
        <a id="Attraktionsbutton" class="btn btn-light disabled" href="${context}/webinterface/attractions"
           role="button"aria-disabled="true">Attraktionen
        </a>
        <a id="Veranstaltungsbutton" class="btn btn-light" href="${context}/webinterface/events?sponsor=${sponsor.name}"
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
            <div class="col-3">
                <h4 class="card-title text-center">Attraktionen editieren</h4>
            </div>
        </div>
        <div class="row justify-content-center">
            <div class="col-3">
                <h6 class="card-title">${sponsor.name} sponsert folgende Attraktionen: </h6>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-3">
                <div class="button-group">
                    <button type="button" class="btn btn-outline-secondary dropdown-toggle" style="width: 250px;" data-toggle="dropdown">
                        <span class="caret">Attraktionen</span>
                    </button>
                    <ul id="attraction-selector" class="dropdown-menu keep-open disabled" style="height: 400px; overflow: auto;">
                        <c:forEach items="${attractions}" var="attraction">
                            <li>
                                <label class="dropdown-item">
                                    <input type="checkbox"
                                           id="checkbox-event-${attraction.id}-attraction-${attraction.name}"
                                    <c:if test="${sponsorAttractions.contains(attraction)}">
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
            <div class="col-3">
                <!-- Speichern Button -->
                <button id="button-save-attractions" class="btn btn-primary btn-success mt-1" style="width: 250px;" onclick="saveAttractions()" role="button">
                    Änderungen speichern
                </button>
                <div class="row">
                    <div class="col" align="center"><p id="ResultStatus"></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="card mt-5 pb-3">
        <div class="row justify-content-center">
            <div class="col-12">
                <c:if test="${sponsorAttractions.size() > 0}">
                    <h4 class="card-title text-center">Überblick über gesponserte Attraktionen</h4>
                </c:if>
                <c:if test="${sponsorAttractions.size() == 0}">
                    <h4 class="card-title">${sponsor.name} hat noch keine Attraktionen eingetragen!</h4>
                </c:if>
            </div>
        </div>
        <div class="row justify-content-center">
            <div class="col-12">
                <div class="container-fluid ">
                    <div class="row justify-content-center">
                        <c:forEach items="${sponsorAttractions}" var="attraction">
                            <a id="attraction-${attraction.name}"
                               href="https://seserver.se.hs-heilbronn.de:9443/buga19bugascout/#/details/${attraction.id}"
                               target="_blank">
                                <div class="card mb-2 mx-3 px-3" style=" width: 312px;">
                                    <span class="d-block p-1 bg-light border-bottom text-dark text-center"><b>${attraction.name}</b></span>
                                    <div class="container">
                                        <div class="card-text text-dark" style="font-size: small">
                                                ${util.truncateLongText(attraction.beschreibung, 350)}
                                        </div>
                                    </div>
                                    <a href="${context}/sponsor?name=${sponsor.name}">
                                        <span class="d-block p-1 bg-light border-top text-center">
                                            <b>Gesponsort von ${sponsor.name}</b>
                                        </span>
                                    </a>
                                </div>
                            </a>
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
