class Student:
    def __init__(self, name, student_id, email, age, department):
        self.name = name
        self.student_id = student_id
        self.__email = email
        self.age = age
        self.department = department
        self.__marks = []

    def display_info(self):
        print("Name:", self.name)
        print("Student ID:", self.student_id)
        print("Email:", self.__email)
        print("Age:", self.age)
        print("Department:", self.department)

    def calculate_result(self, *marks):
        if marks:
            self.__marks = list(marks)

        if not self.__marks:
            return "No marks available"

        total = sum(self.__marks)
        average = total / len(self.__marks)

        if average >= 80:
            grade = "A+"
        elif average >= 70:
            grade = "A"
        elif average >= 60:
            grade = "B"
        elif average >= 50:
            grade = "C"
        elif average >= 40:
            grade = "D"
        else:
            grade = "F"

        return f"Average: {average:.2f}, Grade: {grade}"

    def get_student_type(self):
        return "Regular Student"


class UndergraduateStudent(Student):
    def __init__(self, name, student_id, email, age, department, semester):
        super().__init__(name, student_id, email, age, department)
        self.semester = semester

    def get_student_type(self):
        return "Undergraduate Student"

    def display_info(self):
        super().display_info()
        print("Semester:", self.semester)


class GraduateStudent(Student):
    def __init__(
        self,
        name,
        student_id,
        email,
        age,
        department,
        research_topic
    ):
        super().__init__(name, student_id, email, age, department)
        self.research_topic = research_topic

    def get_student_type(self):
        return "Graduate Student"

    def display_info(self):
        super().display_info()
        print("Research Topic:", self.research_topic)


# Create Undergraduate Student object
student1 = UndergraduateStudent(
    "Rahim",
    "UG001",
    "rahim@example.com",
    20,
    "Computer Science",
    5
)

# Create Graduate Student object
student2 = GraduateStudent(
    "Karim",
    "GR001",
    "karim@example.com",
    25,
    "Computer Science",
    "Artificial Intelligence"
)


print("===== Undergraduate Student =====")
student1.display_info()
print("Student Type:", student1.get_student_type())
print("Result:", student1.calculate_result(85, 78, 90, 88))
print()


print("===== Graduate Student =====")
student2.display_info()
print("Student Type:", student2.get_student_type())
print("Result:", student2.calculate_result(92, 88, 95, 90))
print()


# Polymorphism
print("===== Polymorphism =====")

students = [student1, student2]

for student in students:
    print(student.name, "->", student.get_student_type())