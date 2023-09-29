# Apple Stocks App Clone (Only UI)

This application is a clone of Apple's Stocks application, written in Flutter. The application contains static data and does not have remote API integration. The purpose of the application is solely to create a fluid native Apple-like experience and provide education to viewers throughout this process.

![Static Badge](https://img.shields.io/badge/Author-KSPoyraz-blue)
[![Linkedin: Kspoyraz](https://img.shields.io/badge/Kspoyraz-blue?logo=Linkedin&logoColor=fff)][linkedin]
[![Github: Kspo](https://img.shields.io/badge/Kspo-white?logo=Github&logoColor=000)][github]
![GitHub Licence](https://img.shields.io/github/license/kspo/apple_stocks_app_clone?label=Licence)
![GitHub last commit](https://img.shields.io/github/last-commit/kspo/apple_stocks_app_clone?label=Last+Commit)

## 📸 ScreenShots

|| Real Apple Stocks App| Clone Apple Stocks App|
|-------|------|-------|
|General View|<img src="screenshots/realapp1.jpeg" style="border-radius: 15px;" width="400"/>|<img src="screenshots/cloneapp1.png" style="border-radius: 15px;"  width="400"/>|
|<p>Snap According to Search Text<p>|<img src="screenshots/realapp2.gif" style="border-radius: 15px;width: 400px"/>|<img src="screenshots/cloneapp2.gif" style="border-radius: 15px;width: 400px"/>|
|<p>Persistent DraggableBottom Sheet And extend Marquee<p>|<img src="screenshots/realapp3.gif" style="border-radius: 15px;width: 400px"/>|<img src="screenshots/cloneapp3.gif" style="border-radius: 15px;width: 400px"/>|
|<p>Click any element on list and open detail sheet<p>|<img src="screenshots/realapp4.gif" style="border-radius: 15px;width: 400px"/>|<img src="screenshots/cloneapp4.gif" style="border-radius: 15px;width: 400px"/>|

## App Animations

- Searchbar scroll and sliver.
- There are 2 DraggableScrollableSheet. One is persistent, other is depends on clicking any market on the list.
- After expanding DraggableScrollableSheet, Stock market prices marquee will be shown on AppBar.
- BottomNavigationBar has yahoo!finance logo as Apple does.
- Also BottomNavigationBar is persistent.

## Development Information

- Currently, This app' purpose is to educate viewers. So some unnecessary design details and Easily achievable UI patterns have been overlooked in app.
  
- If you have any question about this app, feel free to get in touch
  
- This app uses these AWESOME dependencies;
  - [marqueer]
  - [pull_down_button]
  - [chart_sparkline]


## Licensing

- This app is distributed under the MIT License.
- See the [LICENSE](LICENSE.md) file for details.

## Connect with Me

- You can connect with me, If you have any specific inquiries or require further information.


[linkedin]: https://www.linkedin.com/in/kaz%C4%B1m-selman-poyraz-0048b7143/
[github]: https://github.com/kspo

[pull_down_button]: https://pub.dev/packages/pull_down_button#pulldownbuttontheme
[marqueer]: https://pub.dev/packages/marqueer
[chart_sparkline]: https://pub.dev/packages/chart_sparkline