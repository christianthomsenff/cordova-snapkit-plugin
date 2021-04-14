class LoginKit {

    async login() {
        return new Promise((resolve, reject) => {
            cordova.exec(resolve, (err) => {
                reject(err);
            }, "LoginKit", "login");
        });
    }

    async logout() {
        return new Promise((resolve, reject) => {
            cordova.exec(resolve, (err) => {
                reject(err);
            }, "LoginKit", "logout");
        });
    }

    async isLoggedIn() {
        return new Promise((resolve, reject) => {
            cordova.exec(resolve, (err) => {
                reject(err);
            }, "LoginKit", "isLoggedIn");
        });
    }

    async addLoginButton() {
        return new Promise((resolve, reject) => {
            cordova.exec(resolve, (err) => {
                reject(err);
            }, "LoginKit", "addLoginButton");

        });
    }

    async fetchUserData(query) {
        return new Promise((resolve, reject) => {
            cordova.exec(resolve, (err) => {
                reject(err);
            }, "LoginKit", "fetchUserData", [query]);
        });
    }
}

class CreativeKit {
    async share(stickerJSON) {
        return new Promise((resolve, reject) => {
            cordova.exec(resolve, (err) => {
                reject(err);
            }, "CreativeKit", "share", [stickerJSON]);
        });
    }
}

class AdKit {

    async init(snapKitAppId) {
        return new Promise((resolve, reject) => {
            cordova.exec(resolve, (err) => {
                reject(err);
            }, "AdKit", "initializeAdKit", [snapKitAppId]);
        });
    }

    async loadInterstitial(slotId) {
        return new Promise((resolve, reject) => {
            cordova.exec(resolve, (err) => {
                reject(err);
            }, "AdKit", "loadInterstitial", [slotId]);
        });
    }

    async loadRewarded(slotId) {
        return new Promise((resolve, reject) => {
            cordova.exec(resolve, (err) => {
                reject(err);
            }, "AdKit", "loadRewarded", [slotId]);
        });
    }

    async playAd() {
        return new Promise((resolve, reject) => {
            cordova.exec(resolve, (err) => {
                reject(err);
            }, "AdKit", "playAd");
        });
    }
}

window.LoginKit = new LoginKit();
window.CreativeKit = new CreativeKit();
window.AdKit = new AdKit();    