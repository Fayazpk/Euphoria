import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
//import LocationController from "../controllers/location_controller"

const application = Application.start()
const context = require.context("controllers", true, /\.js$/)
application.load(definitionsFromContext(context))
