<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="util" type="sponsoren.Util"--%>
<%--@elvariable id="locations" type="java.util.Map<Integer, sponsoren.orm.LocationEntity>"--%>
<%--@elvariable id="events" type="java.lang.List<sponsoren.orm.VeranstaltungEntity>"--%>
<%--@elvariable id="companyPartys" type="java.lang.List<sponsoren.orm.VeranstaltungEntity>"--%>
<%--@elvariable id="searchString" type="java.lang.String"--%>
<%--@elvariable id="eventsSponsors" type="java.util.Map<Integer, java.util.List<String>>"--%>
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
    <script src="${context}/js/searchbar.js"></script>

    <title>Sponsoren-Veranstaltungsliste</title>

    <!-- own css -->
    <link rel="stylesheet" type="text/css" href="${context}/css/background.css" media="screen"/>

</head>
<body class="bg-image">
<nav class="navbar fixed-top navbar-dark bg-dark pb-0" style="min-height: 50px">
    <div class="container justify-content-center">
        <div class="navbar-header">
            <p class="navbar-brand "> Veranstaltungen </p>
            <button input class="btn btn-light" type="submit" data-toggle="collapse"
                    data-target="#navbar-responsive-65"><i class="fas fa-search"></i>
            </button>
        </div>
        <div class="collapse" id="navbar-responsive-65">
            <div class="navbar ">
                <script>
                    function search() {
                        var content = document.getElementById("suchFeld").value;
                        window.location = "${context}/events?search=" + content;
                    }
                </script>
                <form class="search-form searchbar" role="search" id="hiddenSearchBox" action="javascript:search()"
                      method="get">
                    <div class="input-group">
                        <input type="hidden" name="id" value="63">
                        <input id="suchFeld" type="search" name="keywords" class="form-control" placeholder="Suche...">
                        <div class="input-group-btn">
                            <input class="btn btn-light" type="submit" value="Suchen" data-toggle="searchbar"
                                   data-target="#hiddenSearchBox">
                            </input>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</nav>
<nav class="navbar fixed-bottom navbar-expand-lg navbar-dark bg-dark justify-content-center">
    <div class="btn-group" role="group" style="min-width: 100%">
        <a id="Attractionbutton" class="btn btn-primary btn-light" style="border:1px solid black"
           href="${context}/attractions" role="button"><i
                class="fas fa-landmark"></i></a>
        <a id="Homebutton" class="btn btn-primary btn-light" style="border:1px solid black" href="${context}/sponsoren"
        ><i class="fas fa-home"></i></a>
        <a id="Eventbutton" class="btn btn-primary btn-light" href="${context}/events" role="button"
           style="background: aquamarine; border:1px solid black"
        ><i class="far fa-calendar-alt"></i>
        </a>
    </div>
</nav>
<div class="pt-4"></div>
<div class="container-fluid  pb-5 mt-5">
    <c:if test="${searchString != null}">
        <span class="d-block mt-3 p-1 bg-light text-dark text-center"><b>Suchergebnisse für: "${searchString}"</b></span>
    </c:if>
    <div class="row justify-content-center pb-5 mx-1">
        <c:forEach items="${events}" var="event">
            <c:if test="${util.searchMatch(searchString, event)}">


                <div class="card mb-1 mt-1 col-12" style="width: 18rem">
                    <a id="${event.id}card" href="${context}/event?id=${event.id}">
                        <span class="d-block p-1 bg-light text-dark text-center"><b>${event.name}</b></span>
                        <div class="card-body text-dark"><i class="fas fa-thumbtack mr-2"></i>
                                ${locations.get(event.locationID).name}
                            <div class="card-text text-dark text-left d-flex"><i
                                    class="far fa-calendar-alt mr-2"></i>
                                <p>
                                        ${util.prettifyTimestamp(event.start)} -<br>
                                        ${util.prettifyTimestamp(event.ende)}
                                </p>
                            </div>
                        </div>
                    </a>
                    <span class="d-block p-1 bg-light border-top text-center">
                            <b>
                                Gesponsort von
                                <a href="${context}/sponsor?name=${eventsSponsors.get(event.id).get(0)}">${eventsSponsors.get(event.id).get(0)}</a>
                                <c:forEach
                                        items="${eventsSponsors.get(event.id).subList(1, eventsSponsors.get(event.id).size())}"
                                        var="sponsor">
                                    , <a href="${context}/sponsor?name=${sponsor}">${sponsor}</a>
                                </c:forEach>
                            </b>
                    </span>
                </div>

            </c:if>
        </c:forEach>
    </div>
</div>

<nav class="navbar navbar-dark bg-dark justify-content-center" style="min-height: 50px">
    <p class="navbar-text navbar-center text-white" style="font-size: x-large">Betriebsfeiern</p>
</nav>
<div class="container-fluid mt-3">
    <div class="row justify-content-center pb-5 mx-1">
        <c:forEach items="${companyPartys}" var="event">
            <c:if test="${util.searchMatch(searchString, event)}">


                <div class="card mb-2 col-12" style="width: 18rem">
                    <a id="${event.id}card" href="${context}/event?id=${event.id}">
                        <span class="d-block p-1 bg-light text-dark text-center"><b>${event.name}</b></span>
                        <div class="card-body text-dark"><i class="fas fa-thumbtack"></i>
                                ${locations.get(event.locationID).name}
                            <div class="card-text text-dark"><i
                                    class="far fa-calendar-alt"></i> ${util.prettifyTimestamp(event.start)}
                                - ${util.prettifyTimestamp(event.ende)}</div>
                        </div>
                    </a>
                    <span class="d-block p-1 bg-light border-top text-center">
                            <b>
                                Gesponsort von
                                <a href="${context}/sponsor?name=${eventsSponsors.get(event.id).get(0)}">${eventsSponsors.get(event.id).get(0)}</a>
                                <c:forEach
                                        items="${eventsSponsors.get(event.id).subList(1, eventsSponsors.get(event.id).size())}"
                                        var="sponsor">
                                    , <a href="${context}/sponsor?name=${sponsor}">${sponsor}</a>
                                </c:forEach>
                            </b>
                    </span>
                </div>


            </c:if>
        </c:forEach>
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
