# GBM-Challenge
GBM iOS Application Challenge

# Notes to GBM reviewers
Hi! I'm Joaquín González and this is my solution to the challenge. Thank you for reviewing my solution and for your time. Some assumptions I took:

## About the login
* If the device is not enrolled with local auth then the fallback login view will be set.
* Whenever the device is enrolled with local auth the login will be set to login with local auth.
* If local auth fails, the user can opt to use fallback login
* Correct password and user are just empty strings

## About the charts

* I'm displaying all values in the IPC JSON i.e. price, percentage change, volume and change. All vs time in four different charts.

* The JSON provided has a lot of unchanged data, especially for price, so the graph is constant for a bit then drops. I little bit ugly but that is the data :)

## About the list

* The list updates every 10 secs. I know is not ideal but I wanted to make clear that is updating.
* The list doest not change because de data is the same.

## Other notes
* I'm use to have them configurable via plist dictionary but because of time and simplicity I just leave them as simple strings.
* I used MVVM. I think the challenge was fair enough for thin pattern.

# Thank you!
