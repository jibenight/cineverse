import { application } from "./application"

import RatingController from "./rating_controller"
import ThemeController from "./theme_controller"
import SpoilerController from "./spoiler_controller"
import SearchAutocompleteController from "./search_autocomplete_controller"
import DropdownController from "./dropdown_controller"
import FlashController from "./flash_controller"
import ChatController from "./chat_controller"
import AppearanceController from "./appearance_controller"
import SortableController from "./sortable_controller"
import NotificationController from "./notification_controller"

application.register("rating", RatingController)
application.register("theme", ThemeController)
application.register("spoiler", SpoilerController)
application.register("search-autocomplete", SearchAutocompleteController)
application.register("dropdown", DropdownController)
application.register("flash", FlashController)
application.register("chat", ChatController)
application.register("appearance", AppearanceController)
application.register("sortable", SortableController)
application.register("notification", NotificationController)
