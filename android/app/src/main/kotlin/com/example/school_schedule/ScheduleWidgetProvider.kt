package com.example.school_schedule

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class ScheduleWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(
                context.packageName,
                R.layout.schedule_widget
            ).apply {
                val widgetData = HomeWidgetPlugin.getData(context)
                val dayName = widgetData.getString("day_name", "Сегодня")
                val lessonCount = widgetData.getInt("lesson_count", 0)

                setTextViewText(R.id.day_name, dayName)

                if (lessonCount > 0) {
                    // Отображаем уроки
                    for (i in 0 until minOf(lessonCount, 3)) {
                        val subject = widgetData.getString("lesson_${i}_subject", "")
                        val time = widgetData.getString("lesson_${i}_time", "")
                        val classroom = widgetData.getString("lesson_${i}_classroom", "")

                        val lessonText = buildString {
                            append(time)
                            append(" - ")
                            append(subject)
                            if (!classroom.isNullOrEmpty()) {
                                append(" (каб. ")
                                append(classroom)
                                append(")")
                            }
                        }

                        when (i) {
                            0 -> {
                                setTextViewText(R.id.lesson_0, lessonText)
                                setViewVisibility(R.id.lesson_0, android.view.View.VISIBLE)
                            }
                            1 -> {
                                setTextViewText(R.id.lesson_1, lessonText)
                                setViewVisibility(R.id.lesson_1, android.view.View.VISIBLE)
                            }
                            2 -> {
                                setTextViewText(R.id.lesson_2, lessonText)
                                setViewVisibility(R.id.lesson_2, android.view.View.VISIBLE)
                            }
                        }
                    }
                } else {
                    setTextViewText(R.id.lesson_0, "Нет уроков")
                    setViewVisibility(R.id.lesson_0, android.view.View.VISIBLE)
                    setViewVisibility(R.id.lesson_1, android.view.View.GONE)
                    setViewVisibility(R.id.lesson_2, android.view.View.GONE)
                }
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
