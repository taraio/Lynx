$(".hp-authentication-page-register").length?$(".hp-authentication-page-register *[data-button-step]").click((function(){let t=$(this);"register-step-1"===t.attr("data-button-step")&&($(this).addClass("d-none"),$(".hp-authentication-page-register *[data-button-step='register-step-2']").removeClass("d-none"),$(".hp-authentication-page-register *[data-step]").each((function(){"register-step-1"===$(this).attr("data-step")&&$(this).removeClass("d-none")}))),"register-step-2"===t.attr("data-button-step")&&($(this).addClass("d-none"),$(".hp-authentication-page-register *[data-button-step='register-step-3']").removeClass("d-none"),$(".hp-authentication-page-register *[data-step]").each((function(){"register-step-2"===$(this).attr("data-step")&&$(this).removeClass("d-none")}))),"register-step-3"===t.attr("data-button-step")&&($(this).addClass("d-none"),$(".hp-authentication-page-register *[data-button-step='register-step-4']").removeClass("d-none"),$(".hp-authentication-page-register *[data-step]").each((function(){"register-step-3"===$(this).attr("data-step")&&$(this).removeClass("d-none")})))})):$(".hp-authentication-page *[data-button-step]").click((function(){let t=$(this);$(".hp-authentication-page *[data-step]").each((function(){t.attr("data-button-step")===$(this).attr("data-step")&&($(this).removeClass("d-none"),t.addClass("d-none"))}))}));