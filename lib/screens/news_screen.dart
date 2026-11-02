import 'package:flutter/material.dart';

class NewsArticle {
  final String title;
  final String category;
  final String date;
  final String summary;
  final String fullContent;
  final bool isUrgent;

  NewsArticle({
    required this.title,
    required this.category,
    required this.date,
    required this.summary,
    required this.fullContent,
    this.isUrgent = false,
  });
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int _selectedCategoryIndex = 0;

  final List<NewsArticle> _articles = [
    NewsArticle(
      title: 'إعلان جدول امتحانات منتصف الفصل الدراسي الأول',
      category: 'امتحانات',
      date: 'منذ ساعتين • 18 أكتوبر',
      isUrgent: true,
      summary: 'أعلنت إدارة شؤون الطلاب عن جدول الاختبارات لكافة الفرق الدراسية مع مراعاة الإجازات الرسمية.',
      fullContent:
          'تهيب إدارة كلية الحاسبات والمعلومات بجميع الطلاب الالتزام بالحضور قبل موعد الامتحان بنصف ساعة مصطحبين الكارنيه الجامعي، مع حظر اصطحاب الهواتف المحمولة داخل لجان الامتحانات نهائياً.',
    ),
    NewsArticle(
      title: 'فتح باب التقديم للمنح التدريبية لشركة ITI في الأمن السيبراني',
      category: 'تدريب',
      date: 'أمس • 17 أكتوبر',
      summary: 'فرصة لطلاب الفرق الثالثة والرابعة للالتحاق بالبرنامج الصيفي والتدريب العملي المتخصص.',
      fullContent:
          'يتضمن البرنامج دورات تدريبية متقدمة في مجالات الحوسبة السحابية والأمن السيبراني، ويحصل المتدرب على شهادات معتمدة دولياً ومكافآت تدريبية.',
    ),
    NewsArticle(
      title: 'انطلاق دوري كرة القدم والأنشطة الرياضية بالجامعة',
      category: 'أنشطة',
      date: '15 أكتوبر',
      summary: 'تدعو رعاية الشباب الطلاب الراغبين في تمثيل فريق الكلية لتسجيل أسمائهم قبل نهاية الأسبوع.',
      fullContent:
          'ستقام التصفيات التمهيدية على ملاعب القرية الأولمبية بالجامعة بمشاركة كليات المجمع النظري والعلمي، وهناك جوائز قيمة للفائزين بالمراكز الثلاثة الأولى.',
    ),
    NewsArticle(
      title: 'ندوة تعريفية حول الذكاء الاصطناعي التوليدي وسوق العمل',
      category: 'ندوات',
      date: '12 أكتوبر',
      summary: 'تنظم الكلية ندوة تفاعلية بحضور خبراء التكنولوجيا من كبرى الشركات العالمية.',
      fullContent:
          'تتناول الندوة متطلبات سوق العمل البرمجي الحديث وكيفية توظيف أدوات الذكاء الاصطناعي في تطوير المشروعات البرمجية وريادة الأعمال.',
    ),
  ];

  void _openArticleDetails(NewsArticle article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: article.isUrgent
                        ? const Color(0xFFFEE2E2)
                        : const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    article.category,
                    style: TextStyle(
                      color: article.isUrgent
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF4F46E5),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  article.date,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              article.fullContent,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3730A3),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('إغلاق'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('أخبار الجامعة'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildCategoryChip(0, 'الكل'),
                const SizedBox(width: 8),
                _buildCategoryChip(1, 'امتحانات'),
                const SizedBox(width: 8),
                _buildCategoryChip(2, 'تدريب'),
                const SizedBox(width: 8),
                _buildCategoryChip(3, 'أنشطة'),
              ],
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: _articles.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final article = _articles[index];
                return InkWell(
                  onTap: () => _openArticleDetails(article),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: article.isUrgent
                            ? const Color(0xFFFCA5A5)
                            : const Color(0xFFE2E8F0),
                        width: article.isUrgent ? 1.5 : 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(15, 23, 42, 0.03),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: article.isUrgent
                                    ? const Color(0xFFFEE2E2)
                                    : const Color(0xFFEEF2FF),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                article.category,
                                style: TextStyle(
                                  color: article.isUrgent
                                      ? const Color(0xFFDC2626)
                                      : const Color(0xFF4F46E5),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              article.date,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          article.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          article.summary,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              'قراءة الخبر بالكامل',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(int index, String label) {
    final isSelected = _selectedCategoryIndex == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedCategoryIndex = index),
      selectedColor: const Color(0xFF3730A3),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF475569),
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? const Color(0xFF3730A3) : const Color(0xFFCBD5E1),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
