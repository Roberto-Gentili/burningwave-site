/*
jQuery(document).ready(function( jQuery ) {
    jQuery('.counter').counterUp({
        delay: 20,
        time: 2000
    });
});
*/

function setupCounter(counterId, dataURL, refreshTime, delayTime, counterUpTime) {
    var counterBox = document.getElementById(counterId);
    var waitingFunction = window.setInterval(
        function() {
            if (counterBox.innerHTML == "&nbsp;") {
                counterBox.innerHTML = ".";
            } else if (counterBox.innerHTML.length < 3) {
                counterBox.innerHTML += ".";
            } else {
                counterBox.innerHTML = "&nbsp;";
            }
        }, 
        750
    );
    if (!dataURL.startsWith("http")) {
        setTimeout(
            function(counterValue) {
                clearInterval(waitingFunction);
                counterBox.textContent=dataURL;
                jQuery("#" + counterId).counterUp({
                    delay: 20,
                    time: counterUpTime
                });
            },
            delayTime
        );
        return;
    }

    var backgroundSound = new Audio(window.location.origin + "/wp-content/uploads/2022/12/sound-switch.wav");

    var incrementCounter = function (counterBox, counterNewValue) {
        if (backgroundSound == null) {
            counterBox.textContent = counterNewValue;
        }
        backgroundSound.onended = function() {
            if (counterBox.textContent < counterNewValue) {
                incrementCounter(counterBox, counterNewValue);
            }
        };
        backgroundSound.play().then(
            function() {
                setTimeout(
                    function() {
                        counterBox.textContent++;
                    },
                    100
                );
            }
        ).catch(
            function() {
                counterBox.textContent = counterNewValue;
            }
        );
    };

    jQuery.ajax({
        url: dataURL,
        data: null,
        error: function (jqXhr, textStatus, errorMessage) {// error callback 
            clearInterval(waitingFunction);
            counterBox.textContent='NaN';
        },
        dataType: 'json',
        success: function(counterValue) {
            if (counterValue != null) {
                setTimeout(
                    function() {
                        clearInterval(waitingFunction);
                        counterBox.textContent=counterValue;
                        jQuery("#" + counterId).counterUp({
                            delay: 20,
                            time: counterUpTime
                        });
                        window.setInterval(
                            function() {
                                jQuery.ajax({
                                    url: dataURL,
                                    data: null,
                                    dataType: 'json',
                                    success: function(newCounterValue) {
                                        if (counterBox.textContent < newCounterValue) {
                                            incrementCounter(counterBox, newCounterValue);
                                        }                                                    
                                    }
                                });
                            },
                            refreshTime
                        );
                    },
                    delayTime
                );
            } else {
                clearInterval(waitingFunction);
                counterBox.textContent='NaN';
            }
        },
        type: 'GET'
    });
}
