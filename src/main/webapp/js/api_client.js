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
    return fetch('/api/' + what + _xwwwfurlenc(args), {
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
    console.log("_post " + args);
    return fetch('/api/' + what, {
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
 *
 * @param sponsor_name Name of the sponsor, i.e. the key in the database
 * @param beschreibung Beschreibung
 * @param werbetext Werbetext
 * @param adresse Adresse
 * @param anspr_nachname AnsprechpartnerNachname
 * @param anspr_vorname AnsprechpartnerVorname
 * @param email Email
 * @param telefon Telefonnummer
 * @returns {Promise<Response>}
 */
function db_save_sponsor_info(json_info) {
    return _post("sponsor/set_info", json_info);
}

/**
 * Returns the Werbetext of a Sponsor
 * @param sponsor_name Name of the sponsor, i.e. the key in the database
 * @returns {Promise<Response>}
 */
function db_get_werbetext(sponsor_name) {
    return _get("sponsor/werbetext", { name: sponsor_name }).then(_give_json);
}
