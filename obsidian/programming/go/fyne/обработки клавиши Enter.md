#go 
```go
import (
	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/widget"
)

// Создаем новое сочетание клавиш для Enter
type KeyboardEnter struct {
	fyne.Shortcut
}

//Назначаем клавишу Enter
func (k *KeyboardEnter) Key() fyne.KeyName {
	return fyne.KeyReturn // Это для клавиши Enter
}

//Добавление модификатора при котором будет срабатывать Enter
//Используется опционально
func (k *KeyboardEnter) Mod() fyne.KeyModifier {
	return fyne.KeyModifierNone
}

func createRightLowerContent(updateRightUpperContent func(string)) *fyne.Container {
	input := widget.NewEntry()
	input.SetPlaceHolder("Введите ваш вопрос...")

	// Функция для отправки сообщения
	sendMessage := func() {
		go func() {
			response, err := ollama.CallOllamaAPI(input.Text, nil, "llama3-8b-8192")
			if err != nil {
				fyne.CurrentApp().SendNotification(&fyne.Notification{
					Title:   "Ошибка",
					Content: err.Error(),
				})
				updateRightUpperContent("Ошибка: " + err.Error())
				return
			}
			updateRightUpperContent("User: " + input.Text + "\nAI: " + response)
			//Очистить поле ввода после отправки сообщения
			input.SetText("")
		}()
	}

	// Добавляем обработку клавиши Enter
	input.OnSubmitted = func(_ string) {
		sendMessage()
	}

	submitButton := widget.NewButton("Отправить", func() {
		sendMessage()
	})

	return container.NewVBox(input, submitButton)
}

```