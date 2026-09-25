import Foundation

struct HealthArticle: Identifiable, Hashable {
    let id: String
    let titleEN: String
    let titleBN: String
    let bodyEN: String
    let bodyBN: String
    let topic: String
}

enum ArticleCache {
    static let all: [HealthArticle] = [
        article("cycle_basics", "Understanding Your Cycle", "আপনার চক্র বোঝা", topic: "Cycle"),
        article("period_hygiene", "Period Hygiene Tips", "পিরিয়ডে পরিচ্ছন্নতা", topic: "Hygiene"),
        article("nutrition", "Nutrition During Your Cycle", "চক্রজুড়ে পুষ্টি", topic: "Nutrition"),
        article("exercise", "Exercise and Your Cycle", "ব্যায়াম ও চক্র", topic: "Fitness"),
        article("sleep", "Sleep and Hormones", "ঘুম ও হরমোন", topic: "Wellness"),
        article("stress", "Managing Stress", "চাপ মোকাবিলা", topic: "Mental Health"),
        article("pms", "Ease PMS Symptoms", "পিএমএস উপশম", topic: "Symptoms"),
        article("hydration", "Stay Hydrated", "হাইড্রেটেড থাকুন", topic: "Hydration"),
        article("ovulation", "Ovulation Basics", "ডিম্বস্ফোটনের মৌলিক", topic: "Fertility"),
        article("fertile_window", "Fertile Window", "উর্বর সময়", topic: "Fertility"),
        article("pcos_lifestyle", "PCOS-Friendly Lifestyle", "পিসিওএস-বান্ধব জীবন", topic: "Conditions"),
        article("iron", "Iron-Rich Foods", "আয়রন সমৃদ্ধ খাবার", topic: "Nutrition"),
        article("cramps", "Cramp Relief", "পেটব্যথা উপশম", topic: "Symptoms"),
        article("mood", "Mood and Cycle", "মুড ও চক্র", topic: "Mental Health"),
        article("tracking", "Why Track?", "কেন ট্র্যাক করবেন?", topic: "Cycle"),
        article("pregnancy_early", "Early Pregnancy Wellness", "প্রাথমিক গর্ভাবস্থা", topic: "Pregnancy"),
        article("postpartum", "Postpartum Recovery", "প্রসবোত্তর সুস্থতা", topic: "Pregnancy"),
        article("skincare", "Cycle & Skin", "চক্র ও ত্বক", topic: "Wellness"),
        article("meds", "Pain Relief Options", "ব্যথা উপশমের উপায়", topic: "Symptoms"),
        article("community", "Support Networks", "সহায়তা নেটওয়ার্ক", topic: "Wellness"),
        article("doctor", "When to See a Clinician", "কখন চিকিৎসকের কাছে", topic: "Education"),
        article("myths", "Period Myths", "পিরিয়ড সম্পর্কিত ভুল ধারণা", topic: "Education")
    ]

    static func article(
        _ id: String,
        _ titleEN: String,
        _ titleBN: String,
        topic: String
    ) -> HealthArticle {
        HealthArticle(
            id: id,
            titleEN: titleEN,
            titleBN: titleBN,
            bodyEN: "Educational wellness information about \(titleEN.lowercased()). This content supports awareness and self-care—it does not diagnose or treat medical conditions. Consult a qualified clinician for personal medical advice.",
            bodyBN: "\(titleBN) সম্পর্কে শিক্ষামূলক সুস্থতা তথ্য। এটি সচেতনতা ও self-care-এ সহায়তা করে—এটি চিকিৎসা নির্ণয় বা চিকিৎসা নয়। ব্যক্তিগত চিকিৎসা পরামর্শের জন্য যোগ্য চিকিৎসকের সাথে যোগাযোগ করুন।",
            topic: topic
        )
    }
}
