var _context = "";

function api_set_context(context) {
    _context = context;
    console.log("[API] set context: '" + _context + "'");
}

function _path(what) {
    return _context + '/api/' + what;
}

function _xwwwfurlenc(srcjson){
    if(typeof srcjson !== "object") {
        if (typeof console !== "undefined") {
            console.error("_xwwwfurlenc expects JSON object, got " + typeof(srcjson));
            return null;
        }
    }
    var url_params = "";
    var keys = Object.keys(srcjson);
    for(var i=0; i < keys.length; i++){
        url_params += encodeURIComponent(keys[i]) + "=" + encodeURIComponent(srcjson[keys[i]]);
        if(i < (keys.length-1))
            url_params += "&";
    }
    return "?" + url_params;
}

function _get(what, args) {
    return fetch(_path(what) + _xwwwfurlenc(args), {
        method: "GET", // *GET, POST, PUT, DELETE, etc.
        mode: "cors", // no-cors, cors, *same-origin
        cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
        credentials: "same-origin", // include, *same-origin, omit
        headers: {
            "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
        },
        redirect: "follow", // manual, *follow, error
        referrer: "no-referrer" // no-referrer, *client
        //body: JSON.stringify(args) // body data type must match "Content-Type" header
    });
}

function _post(what, args) {
    console.log("_post " + JSON.stringify(args));
    return fetch(_path(what), {
        method: "POST", // *GET, POST, PUT, DELETE, etc.
        mode: "cors", // no-cors, cors, *same-origin
        cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
        credentials: "same-origin", // include, *same-origin, omit
        headers: {
            "Content-Type": "application/json;charset=UTF-8"
        },
        redirect: "follow", // manual, *follow, error
        referrer: "no-referrer", // no-referrer, *client
        body: JSON.stringify(args) // body data type must match "Content-Type" header
    });
}

function _patch(what, args) {
    console.log("_patch " + JSON.stringify(args));
    return fetch(_path(what), {
        method: "PATCH", // *GET, POST, PUT, DELETE, etc.
        mode: "cors", // no-cors, cors, *same-origin
        cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
        credentials: "same-origin", // include, *same-origin, omit
        headers: {
            "Content-Type": "application/json;charset=UTF-8"
        },
        redirect: "follow", // manual, *follow, error
        referrer: "no-referrer", // no-referrer, *client
        body: JSON.stringify(args) // body data type must match "Content-Type" header
    });
}

function _delete(what, args) {
    console.log("_delete " + JSON.stringify(args));
    return fetch(_path(what), {
        method: "DELETE", // *GET, POST, PUT, DELETE, etc.
        mode: "cors", // no-cors, cors, *same-origin
        cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
        credentials: "same-origin", // include, *same-origin, omit
        headers: {
            "Content-Type": "application/json;charset=UTF-8"
        },
        redirect: "follow", // manual, *follow, error
        referrer: "no-referrer", // no-referrer, *client
        body: JSON.stringify(args) // body data type must match "Content-Type" header
    });
}

function _give_json(result) {
    return result.json();
}

function _give_text(result) {
    return result.text();
}


/**
    Returns a promise for the fetch request.

    Expected result data is json representing a row from the sponsor table with given key 'sponsor_name':
    {
        name: string,
        beschreibung: string,
        werbetext: string,
        adresse: string,
        ansprechpartnerNachname: string,
        ansprechpartnerVorname: string,
        email: string,
        telefonnummer: string
    }

    @param sponsor_name Name of the sponsor, i.e. the key in the database
 */
function db_get_sponsor_info(sponsor_name) {
    return _get("sponsor/get_info", { name: sponsor_name }).then(_give_json);
}

/**
 * @param json_info must contain all the fields of SponsorEntitiy
 * @returns {Promise<Response>}
 */
function db_save_sponsor_info(json_info) {
    return _post("sponsor/set_info", json_info);
}

/**
 * Sends a new Veranstaltung to the database
 * @param creator Name of the Sponsor who created this Veranstaltung
 * @param name
 * @param ort
 * @param start_date
 * @param start_time
 * @param ende_date
 * @param ende_time
 * @param beschreibung
 */
function db_send_new_veranstaltung(creator, name, ort, start_date, start_time, ende_date, ende_time, beschreibung) {
    return _post("event/new", {
        creator: creator,
        name: name,
        ort: ort,
        start: start_date + "T" + start_time,
        ende: ende_date + "T" + ende_time,
        beschreibung: beschreibung
    });
}

function db_save_event_data(sponsor, eventId, beschreibung, ort, start_date, start_time, ende_date, ende_time) {
    return _patch("event/edit", {
        id: eventId,
        beschreibung: beschreibung,
        ort: ort,
        start: start_date + "T" + start_time,
        ende: ende_date + "T" + ende_time
    });
}

function db_delete_veranstaltung(eventId, sponsorName) {
    return _delete("event/delete", {
        id: eventId,
        sponsor: sponsorName
    });
}
