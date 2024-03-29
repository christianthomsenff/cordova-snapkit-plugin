class LoginKit {

    async initSDK() {
        return new Promise((resolve, reject) => {
            cordova.exec(resolve, (err) => {
                reject(err);
            }, "LoginKit", "initSDK");
        });
    }

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

    async getAccessToken(query) {
        return new Promise((resolve, reject) => {
            cordova.exec(resolve, (err) => {
                reject(err);
            }, "LoginKit", "getAccessToken");
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

    async playAd(slotId) {
        return new Promise((resolve, reject) => {
            cordova.exec(resolve, (err) => {
                reject(err);
            }, "AdKit", "playAd", [slotId]);
        });
    }
}

window.LoginKit = new LoginKit();
window.CreativeKit = new CreativeKit();
window.AdKit = new AdKit();