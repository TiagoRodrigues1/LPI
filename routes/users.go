package routes

import (
	"projetoapi/controllers"

	"github.com/gin-gonic/gin"
)

func GetUserByID(c *gin.Context) {
	controllers.GetUserByID(c)
}

func UpdateUser(c *gin.Context) {
	controllers.UpdateUser(c)
}

func GetAnimalsFromUserID(c *gin.Context) {
	controllers.GetAnimalsFromUserID(c)
}
