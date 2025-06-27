# GitHub Contributions Chart with TeeChart VCL

This project visualizes a GitHub user's contributions chart using TeeChart VCL. It retrieves contribution data via the public API provided by the [sallar/github-contributions-chart](https://github.com/sallar/github-contributions-chart) project and renders it in a rich, interactive chart.

## Features

- Fetches GitHub contributions data for any user
- Visualizes yearly contributions using TeeChart VCL

## Screenshots

![fed432cdb03f80ae87a626b7ecf204e7da799335](https://github.com/user-attachments/assets/e79cfebe-926b-441c-a595-1404c40e3683)

1. Enter a GitHub username in the application.
2. The app calls the API endpoint:

   ```
   https://github-contributions.vercel.app/api/v1/{username}
   ```

3. The returned data is parsed and displayed as a contributions chart using TeeChart VCL.

## Getting Started

1. Clone this repository.
2. Open the project in your preferred Delphi/C++Builder IDE.
3. Make sure TeeChart VCL is installed.
4. Build and run the application.

## Credits

- Contributions data is provided by the [sallar/github-contributions-chart](https://github.com/sallar/github-contributions-chart) project.
- API endpoint used: `https://github-contributions.vercel.app/api/v1/{username}`

*This project is not affiliated with or endorsed by GitHub or the sallar/github-contributions-chart project.*
