<template>
  <ul>
  <li v-for="course in courses.courses" :key="course.course_id" >
    {{ course.course_name }}
  </li>
  </ul>
</template>

<script setup>
import { useCourseStore } from 'src/stores/courses';

const courses = useCourseStore();

</script>
