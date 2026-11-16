"""Server-side validation for student add/edit forms."""

from __future__ import annotations

from datetime import date

MAX_NAME_LENGTH = 60
MAX_EMAIL_LENGTH = 150
MAX_PHONE_LENGTH = 20
MAX_USN_LENGTH = 20
MAX_ADDRESS_LENGTH = 255
MAX_CITY_LENGTH = 80
MAX_STATE_LENGTH = 80
MAX_PINCODE_LENGTH = 10

VALID_GENDERS = {"male", "female", "other", "prefer_not_to_say"}
VALID_STATUSES = {"active", "inactive", "graduated", "withdrawn"}


def validate_student_form(form: dict) -> tuple[dict, list[str]]:
    """Validate and sanitize student add/edit form data.

    Returns a tuple of ``(cleaned_data, errors)``. ``cleaned_data`` contains
    only the fields that passed validation; ``errors`` lists user-facing
    messages. The password is never echoed back.
    """
    data: dict = {}
    errors: list[str] = []

    def field(name: str) -> str:
        return str(form.get(name, "") or "").strip()

    usn = field("usn")
    if not usn:
        errors.append("Enter the University Seat Number (USN).")
    elif len(usn) > MAX_USN_LENGTH:
        errors.append("The USN is too long.")
    else:
        data["usn"] = usn

    first_name = field("first_name")
    if not first_name:
        errors.append("Enter the student's first name.")
    elif len(first_name) > MAX_NAME_LENGTH:
        errors.append("First name is too long.")
    else:
        data["first_name"] = first_name

    last_name = field("last_name")
    if not last_name:
        errors.append("Enter the student's last name.")
    elif len(last_name) > MAX_NAME_LENGTH:
        errors.append("Last name is too long.")
    else:
        data["last_name"] = last_name

    email = field("email")
    if email and len(email) > MAX_EMAIL_LENGTH:
        errors.append("Email address is too long.")
    elif email and "@" not in email:
        errors.append("Enter a valid email address.")
    else:
        data["email"] = email or None

    phone = field("phone")
    if phone and len(phone) > MAX_PHONE_LENGTH:
        errors.append("Phone number is too long.")
    else:
        data["phone"] = phone or None

    dob_raw = field("date_of_birth")
    if dob_raw:
        try:
            dob = date.fromisoformat(dob_raw)
            if dob > date.today():
                errors.append("Date of birth cannot be in the future.")
            else:
                data["date_of_birth"] = dob_raw
        except ValueError:
            errors.append("Enter a valid date of birth.")
    else:
        data["date_of_birth"] = None

    gender = field("gender")
    if gender and gender not in VALID_GENDERS:
        errors.append("Select a valid gender.")
    else:
        data["gender"] = gender or None

    address_line1 = field("address_line1")
    if address_line1 and len(address_line1) > MAX_ADDRESS_LENGTH:
        errors.append("Address line 1 is too long.")
    else:
        data["address_line1"] = address_line1 or None

    city = field("city")
    if city and len(city) > MAX_CITY_LENGTH:
        errors.append("City is too long.")
    else:
        data["city"] = city or None

    state = field("state")
    if state and len(state) > MAX_STATE_LENGTH:
        errors.append("State is too long.")
    else:
        data["state"] = state or None

    pincode = field("pincode")
    if pincode and len(pincode) > MAX_PINCODE_LENGTH:
        errors.append("Pincode is too long.")
    else:
        data["pincode"] = pincode or None

    admission_year_raw = str(form.get("admission_year", "") or "").strip()
    if not admission_year_raw:
        errors.append("Enter the admission year.")
    else:
        try:
            admission_year = int(admission_year_raw)
            current_year = date.today().year
            if admission_year < 1900 or admission_year > current_year + 5:
                errors.append("Enter a valid admission year.")
            else:
                data["admission_year"] = admission_year
        except ValueError:
            errors.append("Enter a valid admission year.")

    current_semester_raw = str(form.get("current_semester", "") or "").strip()
    if not current_semester_raw:
        errors.append("Enter the current semester.")
    else:
        try:
            current_semester = int(current_semester_raw)
            if current_semester < 1 or current_semester > 12:
                errors.append("Current semester must be between 1 and 12.")
            else:
                data["current_semester"] = current_semester
        except ValueError:
            errors.append("Enter a valid semester number.")

    department_id_raw = str(form.get("department_id", "") or "").strip()
    if not department_id_raw:
        errors.append("Select a department.")
    else:
        try:
            data["department_id"] = int(department_id_raw)
        except ValueError:
            errors.append("Select a valid department.")

    course_id_raw = str(form.get("course_id", "") or "").strip()
    if not course_id_raw:
        errors.append("Select a course.")
    else:
        try:
            data["course_id"] = int(course_id_raw)
        except ValueError:
            errors.append("Select a valid course.")

    status = field("status")
    if status not in VALID_STATUSES:
        errors.append("Select a valid status.")
    else:
        data["status"] = status

    return data, errors